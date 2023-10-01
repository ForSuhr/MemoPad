#ifndef CANVAS_H
#define CANVAS_H

#include <QString>

class Canvas {
public:
    explicit Canvas(QString canvasID, QString canvasName, QString upperCanvasID);

    QString m_canvasID;
    QString m_canvasName;
    QString m_upperCanvasID;
};

#endif // CANVAS_H
