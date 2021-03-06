#include "makelink.h"
#include <iostream>
#include <QTextStream>
#include <QFile>

QString clean(QString p_str) {
    return p_str.trimmed();
}

MakeLink::MakeLink(QObject* parent) :
    QObject( parent ),
    m_errors(""),
    m_results("")
{
}

MakeLink::~MakeLink()
{
}

void MakeLink::callMakeLink(QString pLink, QString pTarget)
{
    QString lCommand("cmd /U /C mklink /J \"%0\" \"%1\" > out 2> err");
    lCommand = lCommand.arg(pLink).arg(pTarget);

    QFile fout("out");
    QFile ferr("err");

    system(lCommand.toStdString().c_str());

    if (fout.open(QIODevice::ReadOnly | QIODevice::Text) && ferr.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream out(&fout);
        QTextStream err(&ferr);

        setResults( out.readAll().trimmed() );
        setErrors( err.readAll().trimmed() );

        fout.remove();
        ferr.remove();
    }
}

void MakeLink::setErrors(QString p_errors) {
    if (p_errors != m_errors) {
        m_errors = p_errors;
        emit(errorsChanged());
    }
}

void MakeLink::setResults(QString p_results) {
    if (p_results != m_results) {
        m_results = p_results;
        emit(resultsChanged());
    }
}

std::ostream& operator<<(std::ostream& out, const MakeLink& p_makeLink)
{
    out << "--> results : " << std::endl << p_makeLink.getResults().toStdString() << std::endl;
    out << "--> errors : " << std::endl << p_makeLink.getErrors().toStdString() << std::endl;

    return out;
}
