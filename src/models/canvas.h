#ifndef CANVAS_H
#define CANVAS_H

#include <QString>

class Canvas {
public:
    explicit Canvas(QString canvasID, QString canvasName);

    QString m_canvasID;
    QString m_canvasName;
};

#endif // CANVAS_H
