view: web_commandes {
  derived_table: {
    sql:
SELECT
  c.CustomerId,
  c.CdCommande,
  c.CanalCommande,
  c.Tarif_HT_Livraison,
  c.Statut,
  c.CdMagasin,
  c.Numero_Commande_Client,
  c.DateCommande,
  pc.ProductId,
  pc.Quantite,
  pc.Tarif_Produit_HT,
  pc.Tarif_Produit_TTC,
  pc.Taux_Marge_Magasin,
  c.CodeTerritoire
FROM Matillion_Perm_Table.Web_Inter_Commande c
INNER JOIN Matillion_Perm_Table.Web_Inter_Produit_Commande pc ON c.CdCommande = pc.CdCommande  ;;
  }
  label: "Commande"

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.CdCommande ;;
    label: "Numéro Commande"
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.CustomerId ;;
    label: "Numéro Client"
    hidden: yes
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.ProductId ;;
    label: "Code Article"
    view_label: "Article"
  }

  dimension: Canal_commande {
    type: string
    sql: ${TABLE}.CanalCommande ;;
    label: "Type Livraison"
  }

  dimension: Tarif_HT_livraison {
    type: number
    sql: ${TABLE}.Tarif_HT_Livraison ;;
    hidden: yes
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.Statut ;;
    label: "Etat Commande"
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CdMagasin ;;
    label: "Code Magasin"
    view_label: "Magasin"
  }

  dimension: Quantite_commandee {
   type: number
   sql: ${TABLE}.Quantite ;;
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
    sql: ${TABLE}.Tarif_Produit_HT * ${TABLE}.Quantite ;;
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
    hidden: yes
  }

  dimension: Numero_Commande_Client {
    type: number
    sql: ${TABLE}.Numero_Commande_Client ;;
    label: "Numéro de Commande du Client"
  }

  dimension: Code_Territoire {
    type: string
    sql: ${TABLE}.CodeTerritoire;;
    label: "Code Territoire"
    hidden:  yes
  }

  dimension_group: dte_commande {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: timestamp
    sql: ${TABLE}.DateCommande ;;
    label: "Date Commande"
  }


  ################
  ### Périodes ###
  ################

  filter: date_filter_N {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N"
    type: date
    group_label: "Périodes"
  }

  filter: date_filter_N1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N-1"
    type: date
    group_label: "Périodes"
  }

  filter: date_filter_N2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période N-2"
    type: date
    group_label: "Périodes"
  }


  #############
  ### CA HT ###
  #############

  measure: ca_ht {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} ;;
    label: "CA HT"
  }

  measure: ca_ht_periode_N {
    type: sum
    value_format_name: eur
    label: "CA HT (N)"
    sql: CASE
            WHEN {% condition date_filter_N %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_periode_N1 {
    label: "CA HT (N-1)"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_N1 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_periode_N2 {
    label: "CA HT (N-2)"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_N2 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT}
          END ;;
    group_label: "Périodes"
  }

  measure: ca_ht_prog_N1_N {
    label: "CA HT (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_ht_periode_N}-${ca_ht_periode_N1})/NULLIF(${ca_ht_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: ca_ht_prog_N2_N1 {
    label: "CA HT (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_ht_periode_N1}-${ca_ht_periode_N2})/NULLIF(${ca_ht_periode_N2},0);;
    group_label: "Périodes"
  }


  #######################
  ### Frais Livraison ###
  #######################

  measure: frais_livraison_ht {
    type: sum_distinct
    value_format_name: eur
    sql_distinct_key: ${cd_commande} ;;
    sql: ${Tarif_HT_livraison} ;;
    label: "Frais Livraison HT"
  }


  #######################
  ### Nombre Commande ###
  #######################

  measure: nombre_commande {
    type: count_distinct
    sql: ${cd_commande} ;;
    label: "Nombre Commandes"
  }

  measure: nombre_commande_periode_N {
    type: count_distinct
    label: "Nombre Commandes (N)"
    sql: CASE
            WHEN {% condition date_filter_N %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_periode_N1 {
    label: "Nombre Commandes (N-1)"
    type: count_distinct
    sql: CASE
            WHEN {% condition date_filter_N1 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_periode_N2 {
    label: "Nombre Commandes (N-2)"
    type: count_distinct
    sql: CASE
            WHEN {% condition date_filter_N2 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_commande}
          END ;;
    group_label: "Périodes"
  }

  measure: nombre_commande_prog_N1_N {
    label: "Nombre Commandes (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${nombre_commande_periode_N}-${nombre_commande_periode_N1})/NULLIF(${nombre_commande_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: nombre_commande_prog_N2_N1 {
    label: "Nombre Commandes (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${nombre_commande_periode_N1}-${nombre_commande_periode_N2})/NULLIF(${nombre_commande_periode_N2},0);;
    group_label: "Périodes"
  }


  ###############################
  ### Nombre Nouveaux Clients ###
  ###############################

  measure: nombre_nouveau_client {
    type: count_distinct
    sql: ${cd_commande} ;;
    filters: [ Numero_Commande_Client: "1" ]
    label: "Nombre Nouveaux Clients"
  }


  ####################
  ### Panier Moyen ###
  ####################

  measure: panier_moyen {
    type: number
    value_format_name: eur
    sql: ${ca_ht} /  ${nombre_commande} ;;
    label: "Panier Moyen"
  }

  measure: panier_moyen_periode_N {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N)"
    sql: ${ca_ht_periode_N} /  NULLIF(${nombre_commande_periode_N},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_periode_N1 {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N-1)"
    sql: ${ca_ht_periode_N1} /  NULLIF(${nombre_commande_periode_N1},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_periode_N2 {
    type: number
    value_format_name: eur
    label: "Panier Moyen (N-2)"
    sql: ${ca_ht_periode_N2} /  NULLIF(${nombre_commande_periode_N2},0) ;;
    group_label: "Périodes"
  }

  measure: panier_moyen_prog_N1_N {
    label: "Panier Moyen (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_periode_N}-${panier_moyen_periode_N1})/NULLIF(${panier_moyen_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: panier_moyen_prog_N2_N1 {
    label: "Panier Moyen (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_periode_N1}-${panier_moyen_periode_N2})/NULLIF(${panier_moyen_periode_N2},0);;
    group_label: "Périodes"
  }


  ########################
  ### Nombre d'Article ###
  ########################

  measure: Nombre_Article {
    type: sum
    sql: ${Quantite_commandee} ;;
    label: "Nombre Article"
  }

  measure: Nombre_Article_Distinct {
    type: count_distinct
    sql: ${cd_produit} ;;
    label: "Nombre Article Distinct"
  }


  ###########################
  ### Prix de Vente Moyen ###
  ###########################

  measure: Prix_Vente_Moyen {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} / NULLIF(${Quantite_commandee},0) ;;
    label: "Prix de Vente Moyen"
  }


  #############
  ### Marge ###
  #############

  measure: Marge {
    type: sum
    value_format_name: eur
    sql: ${Total_Produit_HT} * ${Taux_Marge_Magasin} ;;
    label: "Marge"
  }

  measure: Marge_periode_N {
    type: sum
    value_format_name: eur
    label: "Marge (N)"
    sql: CASE
            WHEN {% condition date_filter_N %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT} * ${Taux_Marge_Magasin}
          END ;;
    group_label: "Périodes"
  }

  measure: Marge_periode_N1 {
    type: sum
    value_format_name: eur
    label: "Marge (N-1)"
    sql: CASE
            WHEN {% condition date_filter_N1 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT} * ${Taux_Marge_Magasin}
          END ;;
    group_label: "Périodes"
  }

  measure: Marge_periode_N2 {
    type: sum
    value_format_name: eur
    label: "Marge (N-2)"
    sql: CASE
            WHEN {% condition date_filter_N2 %} CAST(${dte_commande_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${Total_Produit_HT} * ${Taux_Marge_Magasin}
          END ;;
    group_label: "Périodes"
  }

  measure: Marge_prog_N1_N {
    label: "Marge (prog N-1 à N)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${Marge_periode_N}-${Marge_periode_N1})/NULLIF(${Marge_periode_N1},0);;
    group_label: "Périodes"
  }

  measure: Marge_prog_N2_N1 {
    label: "Marge (prog N-2 à N-1)"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${Marge_periode_N1}-${Marge_periode_N2})/NULLIF(${Marge_periode_N2},0);;
    group_label: "Périodes"
  }


  ###########################
  ### Taux de Marge Moyen ###
  ###########################

  measure: TauxMargeMoyen {
    type: number
    value_format_name: percent_2
    sql: ${Marge} / NULLIF(${ca_ht},0) ;;
    label: "Taux Marge Moyen"
  }

}
