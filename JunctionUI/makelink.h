#ifndef MAKELINK_H
#define MAKELINK_H

#include <QObject>
#include <QString>

class MakeLink : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString help         READ getHelp    NOTIFY helpChanged)
    Q_PROPERTY(QString errors       READ getErrors  NOTIFY errorsChanged)
    Q_PROPERTY(QString results      READ getResults NOTIFY resultsChanged)
public:
    explicit MakeLink(QObject* parent = 0);
    ~MakeLink();

    Q_INVOKABLE void callMakeLink(QString pOptions, QString pLink, QString pTarget);

    QString getHelp() const       { return m_help; }
    QString getErrors() const     { return m_errors; }
    QString getResults() const    { return m_results; }

    friend std::ostream& operator<<(std::ostream& out, const MakeLink& p_makeLink);

signals:
    void helpChanged();
    void errorsChanged();
    void resultsChanged();

private:
    /* setters */
    void setErrors(QString p_errors);
    void setResults(QString p_results);

    /* attributes */
    QString m_help;
    QString m_errors;
    QString m_results;
};

#endif // MAKELINK_H
