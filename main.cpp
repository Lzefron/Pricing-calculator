#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "calculator.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    calculator myCalc;
    QQmlApplicationEngine engine;

    // Export C++ to QML
    engine.rootContext()->setContextProperty("CalcEngine", &myCalc);

    // FIX 1: The Path. In Qt 6, the standard path follows this pattern:
    // qrc:/qt/qml/[ProjectName]/[FileName].qml
    const QUrl url(u"qrc:/qt/qml/LunaraCalculator/Main.qml"_qs);

    // FIX 2: The Error Handler
    // This connects to the engine and tells the app to CLOSE if the QML fails to load
    // instead of just hanging in the background.
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    engine.load(url);

    // FIX 3: Check if the engine actually loaded anything
    if (engine.rootObjects().isEmpty()) {
        qDebug() << "--- LUNARA ERROR: Could not find Main.qml at the specified path! ---";
        return -1;
    }

    return app.exec();
}
