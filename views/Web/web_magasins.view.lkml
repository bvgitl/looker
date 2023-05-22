view: web_magasins {
  sql_table_name: `Matillion_Perm_Table.Magasins`
    ;;
  label: "Magasin"

  dimension: CD_Magasin {
    type: string
    primary_key: yes
    sql: ${TABLE}.CD_Magasin ;;
    label: "Code Magasin"
    hidden: yes
  }

  dimension: Nom_TBE {
    type: string
    sql: ${TABLE}.Nom_TBE ;;
    label: "Nom Magasin"
  }

  dimension: Enseigne {
    type: string
    primary_key: yes
    sql: ${TABLE}.Enseigne_nom ;;
    label: "Enseigne"
    hidden: yes
  }

}
