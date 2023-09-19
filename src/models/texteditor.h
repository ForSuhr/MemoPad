#ifndef TEXT_EDITOR_H
#define TEXT_EDITOR_H

#include <QCoreApplication>
#include <QDebug>
#include <QFile>
#include <QObject>
#include <QTextStream>

class TextEditor : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(QString data READ data WRITE setData NOTIFY dataChanged)
public:
    explicit TextEditor(QObject* parent = nullptr);

    QString path();
    void setPath(QString path);
    QString data();
    void setData(QString data);

signals:
    void pathChanged();
    void dataChanged();

private:
    QString m_path;
};

#endif // TEXT_EDITOR_MODEL_H
