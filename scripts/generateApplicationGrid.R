generateApplicationGrid <- function(catName) {
  categoryApps <- getCompanyAppsForCategory(catName)
  result <- '<div class="row">'
  for (appId in categoryApps$id) {
    paste0(result,
           '<div class="col-4"><img class="appIconGridItem" src="',
           getAppIcon(appId),
           '"></div>'
    ) -> result
  }
  result <- paste0(result, '</div>')
  return(result)
}
