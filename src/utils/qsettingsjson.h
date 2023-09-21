/**
 * QSettingsJSON is an implementation of en- & decoding JSON files, where JsonFormat is defined.
 * JsonFormat is a custom format written at the top of QSettings, designed to write and read JSON files,
 * as the original QSettings from Qt library does not support JSON encoding and decoding.
 **/

#ifndef QSETTINGS_JSON_H
#define QSETTINGS_JSON_H

#include <QIODevice>
#include <QMap>
#include <QSettings>
#include <QJsonValue>
#include <QJsonObject>

bool readSettingsJson(QIODevice &device, QMap<QString, QVariant> &map);
bool writeSettingsJson(QIODevice &device, const QMap<QString, QVariant> &map);

void parseJsonObject(QJsonObject &json, QString prefix, QMap<QString, QVariant> &map);
QJsonObject restoreJsonObject(QMap<QString, QVariant> &map);

static const QSettings::Format JsonFormat = QSettings::registerFormat("JsonFormat", &readSettingsJson, &writeSettingsJson);

#endif // QSETTINGS_JSON_H