view: article_arbo {
  sql_table_name: `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE`
    ;;

  dimension: cd_article {
    type: string
    hidden: yes
    sql: ${TABLE}.CodeArticle ;;
  }

  dimension: n4 {
    type: string
    sql: ${TABLE}.N4 ;;
  }

  dimension: n3_sous_famille {
    type: string
    sql: ${TABLE}.N3_SousFamille ;;
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
  }

}
