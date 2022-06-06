view: web_commandes_produits {
  sql_table_name: `Matillion_Perm_Table.Produit_Commande`
    ;;
  #label: "Commandes Web"
  view_label: "Commande"

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${cd_commande}, '@', ${cd_produit}, '@', ${Tarif_Produit_HT}, '@', ${Tarif_Produit_TTC}) ;;
  }

  dimension: cd_commande {
    type: string
    sql: CAST(${TABLE}.cd_commande AS STRING) ;;
    label: "Numéro Commande"
    hidden: yes
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.cd_produit ;;
    label: "Code Article"
    view_label: "Article"
  }

  dimension: Quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
    hidden: yes
  }

  dimension: Tarif_Produit_HT {
    type: number
    value_format_name: eur
    sql: ${TABLE}.Tarif_Produit_HT ;;
    label: "Prix Unitaire HT"
  }

  dimension: Total_Produit_HT {
    type: number
    sql: ${TABLE}.Tarif_Produit_HT * ${TABLE}.Quantite_commandee ;;
    hidden: yes
  }

  dimension: Tarif_Produit_TTC {
    type: number
    sql: ${TABLE}.Tarif_Produit_TTC ;;
    hidden: yes
  }

  dimension: Taux_Marge_Magasin {
    type: number
    value_format_name: percent_2
    sql: ${TABLE}.Taux_Marge_Magasin ;;
    label: "Taux de Marge (magasin)"
  }

  measure: Quantite {
    type: sum
    sql: ${Quantite_commandee} ;;
    label: "Quantité"
  }

  measure: Prix_Total_HT {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} ;;
    label: "Prix Total HT"
  }

  measure: Marge {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} * ${Taux_Marge_Magasin} ;;
    label: "Marge"
  }

  measure: TauxMargeMoyen {
    type: number
    value_format_name: percent_2
    sql: ${Marge} / ${Prix_Total_HT} ;;
    label: "Taux Marge Moyen"
  }

  measure: Prix_Vente_Moyen {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} / ${Quantite_commandee} ;;
    label: "Prix de Vente Moyen"
  }

  measure: Nombre_Article {
    type: count
    label: "Nombre Article"
  }

}
