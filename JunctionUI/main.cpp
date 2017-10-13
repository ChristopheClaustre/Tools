#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "makelink.h"
#include <string>
#include <streambuf>
#include <ostream>
#include <sstream>
#include <iostream>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<MakeLink>("MakeLink", 1, 0, "MakeLink");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
