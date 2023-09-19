#include "texteditor.h"

TextEditor::TextEditor(QObject* parent)
    : QObject { parent }
{
    m_path = QCoreApplication::applicationDirPath();
    m_path.append("/undefined.txt");
}

QString TextEditor::path() { return m_path; }

void TextEditor::setPath(QString path)
{
    m_path = path;
    m_path.remove("file://");
    emit pathChanged();
}

QString TextEditor::data()
{
    QFile file(m_path);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Can not read from file: " << m_path;
        return "";
    }

    QTextStream stream(&file);
    QString data = stream.readAll();
    file.close();
    return data;
}

void TextEditor::setData(QString data)
{
    QFile file(m_path);
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Can not write to file: " << m_path;
    }

    QTextStream stream(&file);
    stream << data;
    file.close();
    emit dataChanged();
}
