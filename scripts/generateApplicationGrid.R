generateApplicationGrid <- function(catName, appList) {
    if (missing(appList) && !missing(catName)) {
        appsToShow <- getCompanyAppsForCategory(catName)
    } else if (missing(catName) && !missing(appList)) {
        appsToShow <- appList
    }
    result <- '<div class="row">'
    for (appId in appsToShow$id) {
        paste0(result,
               '<div class="col-4"><img class="appIconGridItem" src="',
               getAppIcon(appId),
               '"></div>'
        ) -> result
    }
    result <- paste0(result, '</div>')
    return(result)
}
