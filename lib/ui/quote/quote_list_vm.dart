import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/quote/quote_actions.dart';
import 'package:invoiceninja_flutter/redux/quote/quote_selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/ui/list_ui_state.dart';
import 'file:///C:/Users/hillel/Documents/flutter-mobile/lib/ui/quote/quote_presenter.dart';
import 'package:invoiceninja_flutter/ui/invoice/invoice_list.dart';
import 'package:invoiceninja_flutter/ui/invoice/invoice_list_vm.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class QuoteListBuilder extends StatelessWidget {
  const QuoteListBuilder({Key key}) : super(key: key);

  static const String route = '/quote/edit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, QuoteListVM>(
      converter: QuoteListVM.fromStore,
      builder: (context, vm) {
        return InvoiceList(
          viewModel: vm,
        );
      },
    );
  }
}

class QuoteListVM extends EntityListVM {
  QuoteListVM({
    AppState state,
    UserEntity user,
    ListUIState listState,
    List<String> invoiceList,
    BuiltMap<String, InvoiceEntity> invoiceMap,
    BuiltMap<String, ClientEntity> clientMap,
    String filter,
    bool isLoading,
    bool isLoaded,
    Function(BuildContext, InvoiceEntity) onInvoiceTap,
    Function(BuildContext) onRefreshed,
    Function onClearEntityFilterPressed,
    Function(BuildContext) onViewEntityFilterPressed,
    Function(BuildContext, List<InvoiceEntity>, EntityAction) onEntityAction,
    List<String> tableColumns,
    EntityType entityType,
  }) : super(
          state: state,
          user: user,
          listState: listState,
          invoiceList: invoiceList,
          invoiceMap: invoiceMap,
          clientMap: clientMap,
          filter: filter,
          isLoading: isLoading,
          isLoaded: isLoaded,
          onInvoiceTap: onInvoiceTap,
          onRefreshed: onRefreshed,
          onClearEntityFilterPressed: onClearEntityFilterPressed,
          onViewEntityFilterPressed: onViewEntityFilterPressed,
          tableColumns: tableColumns,
          entityType: entityType,
        );

  static QuoteListVM fromStore(Store<AppState> store) {
    Future<Null> _handleRefresh(BuildContext context) {
      if (store.state.isLoading) {
        return Future<Null>(null);
      }
      final completer = snackBarCompleter<Null>(
          context, AppLocalization.of(context).refreshComplete);
      store.dispatch(LoadQuotes(completer: completer, force: true));
      return completer.future;
    }

    final state = store.state;

    return QuoteListVM(
      state: state,
      user: state.user,
      listState: state.quoteListState,
      invoiceList: memoizedFilteredQuoteList(state.quoteState.map,
          state.quoteState.list, state.clientState.map, state.quoteListState),
      invoiceMap: state.quoteState.map,
      clientMap: state.clientState.map,
      isLoading: state.isLoading,
      isLoaded: state.quoteState.isLoaded && state.clientState.isLoaded,
      filter: state.quoteListState.filter,
      onInvoiceTap: (context, quote) {
        viewEntity(context: context, entity: quote);
      },
      onRefreshed: (context) => _handleRefresh(context),
      onClearEntityFilterPressed: () => store.dispatch(FilterQuotesByEntity()),
      onViewEntityFilterPressed: (BuildContext context) => viewEntityById(
          context: context,
          entityId: state.quoteListState.filterEntityId,
          entityType: state.quoteListState.filterEntityType),
      onEntityAction: (BuildContext context, List<BaseEntity> quotes,
              EntityAction action) =>
          handleQuoteAction(context, quotes, action),
      tableColumns: QuotePresenter.getTableFields(state.userCompany),
      entityType: EntityType.quote,
    );
  }
}
