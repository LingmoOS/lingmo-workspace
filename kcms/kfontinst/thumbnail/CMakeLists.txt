kcoreaddons_add_plugin(fontthumbnail SOURCES FontThumbnail.cpp INSTALL_NAMESPACE "kf6/thumbcreator")

ecm_qt_declare_logging_category(fontthumbnail
    HEADER debug.h
    IDENTIFIER KCM_KFONTINST_THUMBNAIL
    CATEGORY_NAME org.kde.kcm_kfontinst.thumbnail
    DESCRIPTION "kcm kfontinst thumbnail"
    EXPORT LINGMOWORKSPACE
)

target_link_libraries(fontthumbnail KF6::Archive KF6::KIOCore KF6::KIOWidgets kfontinstui kfontinst )
