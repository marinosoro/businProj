revenueModels <- matrix(c(1, "payable", 2, "free", 3, "payable with in-app purchases", 4, "free with in-app purchases", "N/A", "No model specified"), ncol = 2, byrow = TRUE)
colnames(revenueModels) <- c("model", "description")
revenueModels <- as.data.frame(revenueModels)