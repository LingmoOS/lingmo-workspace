set(ksplashqml_SRCS
    main.cpp
    splashapp.cpp
    splashwindow.cpp
   )

add_executable(ksplashqml ${ksplashqml_SRCS})

target_link_libraries(ksplashqml
    Qt::Quick
    Qt::DBus
    KF6::ConfigCore
    KF6::Package
    KF6::WindowSystem
    Lingmo::LingmoQuick
    PW::KWorkspace
    LayerShellQt::Interface
   )

ecm_qt_declare_logging_category(ksplashqml
   HEADER debug.h
   IDENTIFIER KSPLASHQML_DEBUG
   CATEGORY_NAME org.kde.lingmo.ksplashqml
   DESCRIPTION "ksplashqml debug"
)

install(TARGETS ksplashqml ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.KSplash.xml DESTINATION ${KDE_INSTALL_DBUSINTERFACEDIR})

ecm_install_configured_files(INPUT lingmo-ksplash.service.in @ONLY DESTINATION  ${KDE_INSTALL_SYSTEMDUSERUNITDIR})
