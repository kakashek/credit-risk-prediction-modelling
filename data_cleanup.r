process_data <- function(df) {
  is.na(df) <- df == "n/a"

  # New column replacing strings with numbers
  emp_length_replace <- c(
    "< 1 year" = "0", "1 year" = "1", "2 years" = "2", "3 years" = "3",
    "4 years" = "4", "5 years" = "5", "6 years" = "6", "7 years" = "7",
    "8 years" = "8", "9 years" = "9", "10\\+ years" = "10"
  )
  df$emp_length <- str_replace_all(df$emp_length, emp_length_replace)

  # Set new column as numeric
  df$emp_length <- as.numeric(df$emp_length)

  # Change repay_fail to factor
  df$repay_fail <- as.factor(df$repay_fail)

  df$pub_rec_categorical <- ifelse(df$pub_rec > 0, 1, 0)
  df$delinq_2yrs_categorical <- ifelse(df$delinq_2yrs > 0, 1, 0)
  df$inq_last_6mths_categorical <- ifelse(df$inq_last_6mths > 0, 1, 0)

  df$pub_rec_categorical <- as.factor(df$pub_rec_categorical)
  df$delinq_2yrs_categorical <- as.factor(df$delinq_2yrs_categorical)
  df$inq_last_6mths_categorical <- as.factor(df$inq_last_6mths_categorical)

  # Remove "months" from term and convert to factor
  term_replace <- c("36 months" = "36", "60 months" = "60")
  df$term <- as.factor(str_replace_all(df$term, term_replace))

  # Convert home_ownership to factor
  df$home_ownership <- as.factor(df$home_ownership)

  # Convert verification_status to factor
  df$verification_status <- as.factor(df$verification_status)

  # convert purpose to factor
  df$purpose <- as.factor(df$purpose)

  df$log_annual_inc <- log(df$annual_inc)
  df$log_revol_bal <- log(df$revol_bal + 1)
  df$log_loan_amnt <- log(df$loan_amnt)

  df <- subset(df, select = -c(annual_inc, pub_rec, delinq_2yrs, inq_last_6mths, revol_bal, loan_amnt))

  return(df)
}

remove_na <- function(df) {
  df <- df %>% filter(!is.na(emp_length))

  # return (df)
}

plot_auc <- function(model, use_data) {
  num_rows <- nrow(use_data)
  pred.cv <- rep(0, num_rows)
  for (i in 0:num_rows) {
    pred.cv[i] <- predict(model, newdata = use_data[i, ])
  }
  pred.cv <- exp(pred.cv) / (1 + exp(pred.cv))

  plot(use_data[0:num_rows, "repay_fail"], pred.cv)

  g <- roc(use_data[0:num_rows, "repay_fail"] ~ pred.cv)
  plot(g)
  cat("AUC: ", g$auc, " gini index: ", (2 * g$auc) - 1, "\n")
}

# to plot just the ROC curve
plot_roc <- function(use_model, use_data) {
  pred <- predict(use_model, use_data, type = c("response"), allow.new.levels = TRUE)
  g <- roc(use_data$repay_fail ~ pred)
  cat("AUC: ", g$auc, " gini index: ", (2 * g$auc) - 1, "\n")
  plot(g)
}

process_ev_data <- function(df) {
  # convert issue_d into date value
  df$issue_d <- dmy(paste0("01-", ev$issue_d))

  # Convert issue_D to factor
  df$issue_d <- as.factor(df$issue_d)

  # convert earliest_cr_line into date value
  df$earliest_cr_line <- dmy(paste0("01-", ev$earliest_cr_line))

  # Remove xx from zip code
  df$zip_code <- sub("xx$", "", ev$zip_code)
  df$zip_code <- as.factor(df$zip_code)

  # convert addr_state into factor
  df$addr_state <- factor(ev$addr_state)

  return(df)
}

# calculation prediction vector
pred <- function(use_model, use_data) {
  predict(use_model, use_data, type = c("response"))
}

# calculate roc curve
calc_roc <- function(use_data, use_pred) {
  roc(use_data$repay_fail ~ use_pred)
}

# calculate ROC curve coordinates
roc_coords <- function(use_roc) {
  round(coords(both.sel.AIC.TotAcc.roc, x = "best", ret = c("threshold", "specificity", "sensitivity", "accuracy")), 5)
}
