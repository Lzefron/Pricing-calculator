#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QObject>

class calculator : public QObject
{
    Q_OBJECT // This macro is essential for QML communication
public:
    explicit calculator(QObject *parent = nullptr) : QObject(parent) {}

    // Q_INVOKABLE allows QML to call this function
    Q_INVOKABLE double calculateTotal(double rate, double price, double weight, QString profitStr) {
        // Shipping rate for Bangladesh (adjust as needed, e.g., 800 BDT/kg)
        double shippingRate = 800.0;
        //shippingrate is not used here.so no need to panic
        double costInBdt = (price * rate) + weight;

        double finalPrice = 0;

        // Smart Profit Logic
        if (profitStr.contains("%")) {
            double percent = profitStr.replace("%", "").toDouble();
            finalPrice = costInBdt * (1 + (percent / 100.0));
        } else {
            double flatProfit = profitStr.toDouble();
            finalPrice = costInBdt + flatProfit;
        }

        return finalPrice;
    }
};

#endif // CALCULATOR_H
