/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtPurchasing 1.15 as QtPurchasing
import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.Item
{
    property alias store: store
    property string failedProductErrorString: ""
    property var failedProduct: null
    property var products: ({})
    readonly property var tipsModel: [
        { name: "bone"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Bone (for Denver)") },
        { name: "coffee"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Coffee")            },
        { name: "cookie"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Cookie")            },
        { name: "icecream", tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me an Ice Cream")        },
        { name: "beer"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Beer")              },
        { name: "burger"  , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Burger")            },
        { name: "wine"    , tooltip: QT_TRANSLATE_NOOP("Tips", "Tip me a Wine Bottle")       }
    ]

    QtQuick.Instantiator
    {
        active: HelpersJS.isPurchasing
        model: tipsModel

        onObjectAdded:
        {
            store.products.push(object);
            products[model[index].name] = object;
            productsChanged();
        }

        QtPurchasing.Product
        {
            identifier: "io.kokleeko.wordclock.tip.%1".arg(modelData.name)
            type: QtPurchasing.Product.Consumable

            onPurchaseSucceeded: (transaction) => store.success(transaction)
            onPurchaseFailed: (transaction) => store.failed(transaction, this)
        }
    }
    QtPurchasing.Store
    {
        id: store

        property bool purchasing: false

        function failed(transaction, product)
        {
            if (transaction)
            {
                transaction.finalize();
                failedProduct = product;
                failedProductErrorString = transaction.errorString;
                failedTransactionPopup.open();
            }
            else
            {
                purchasing = false;
            }
        }
        function success(transaction)
        {
            if (transaction)
            {
                transaction.finalize();
            }
            tipsThanksPopup.open();
            purchasing = false;
        }

        onPurchasingChanged:
        {
            if (!purchasing)
            {
                failedProduct = null;
                failedProductErrorString = "";
            }
        }
    }
}
