set (ion_bbcukmet_SRCS ion_bbcukmet.cpp)
ecm_qt_declare_logging_category(ion_bbcukmet_SRCS
    HEADER ion_bbcukmetdebug.h
    IDENTIFIER IONENGINE_BBCUKMET
    CATEGORY_NAME kde.dataengine.ion.bbcukmet
    DEFAULT_SEVERITY Info
    DESCRIPTION "DataEngine ion bbcukmet"
    EXPORT LINGMOWORKSPACE
)
add_library(lingmo_engine_bbcukmet MODULE ${ion_bbcukmet_SRCS})
target_link_libraries (lingmo_engine_bbcukmet
    weather_ion
    KF6::KIOCore
    KF6::UnitConversion
    KF6::I18n
)

install (TARGETS lingmo_engine_bbcukmet DESTINATION ${KDE_INSTALL_PLUGINDIR}/lingmo5support/dataengine)

