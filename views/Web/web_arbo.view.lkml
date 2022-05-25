view: web_arbo {
  sql_table_name: `Matillion_Perm_Table.ARTICLE_ARBORESCENCE`
    ;;
  label: "Article"

  dimension: CodeArticle {
    primary_key: yes
    type: string
    sql: ${TABLE}.CodeArticle ;;
    hidden: yes
  }

  dimension: N1_Division {
    type: string
    sql: ${TABLE}.N1_Division ;;
    label: "N1 Division"
  }

  dimension: N2_Famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
    label: "N2 Famille"
  }

  dimension: N3_SousFamille {
    type: string
    sql: ${TABLE}.N3_SousFamille ;;
    label: "N3 SousFamille"
  }

  dimension: N4 {
    type: string
    sql: ${TABLE}.N4 ;;
    label: "N4"
  }

}
