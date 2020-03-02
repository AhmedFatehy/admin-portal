import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/data/models/credit_model.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/presenters/entity_presenter.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';

class CreditPresenter extends EntityPresenter {
  static List<String> getTableFields(UserCompanyEntity userCompany) {
    return [
    ];
  }

  @override
  Widget getField({String field, BuildContext context}) {
    final state = StoreProvider.of<AppState>(context).state;
    final credit = entity as InvoiceEntity;

    switch (field) {
    }

    return super.getField(field: field, context: context);
  }
}
