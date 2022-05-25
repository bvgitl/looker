view: web_articles {
  sql_table_name: `Matillion_Perm_Table.ARTICLE_DWH`
    ;;
  label: "Article"

  dimension: c_Article {
    primary_key: yes
    type: string
    sql: ${TABLE}.c_Article ;;
    hidden: yes
  }

  dimension: l_Description {
    type: string
    sql: ${TABLE}.l_Description ;;
    label: "Libellé Article"
  }

  dimension: c_Note {
    type: string
    sql: ${TABLE}.c_Note ;;
    label: "Note Ecologique"
  }

  dimension: statut_article {
    type: string
    sql: CASE ${TABLE}.c_Validite_1 WHEN 1 THEN 'Actif' WHEN 5 THEN 'En liquidation' ELSE '???' END ;;
    label: "Statut Article"
  }

}
