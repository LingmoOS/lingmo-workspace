/*
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

#pragma once

#include <Lingmo/Applet>

class QDateTime;

class CalendarApplet : public Lingmo::Applet
{
    Q_OBJECT

public:
    explicit CalendarApplet(QObject *parent, const KPluginMetaData &data, const QVariantList &args);
    ~CalendarApplet() override;

    Q_INVOKABLE int weekNumber(const QDateTime &dateTime) const;
};
