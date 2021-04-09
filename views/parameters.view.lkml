view: parameters {

  parameter: top_n {
    label: "Top N"

    type: unquoted

    allowed_value: {
      label: "Top 5"
      value: "5"
    }

    allowed_value: {
      label: "Top 10"
      value: "10"
    }

    allowed_value: {
      label: "Top 15"
      value: "15"
    }

    default_value: "5"
  }

}
