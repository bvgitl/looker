view: ventes_devise {
  sql_table_name: `bv-prod.Matillion_Perm_Table.ventes_devise`
    ;;

  dimension: cd_devise {
    type: string
    sql: ${TABLE}.cd_devise ;;
  }

  dimension: cd_acteur {
    type: string
    sql: ${TABLE}.cd_acteur ;;
  }

  dimension_group: dte_vente {
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
    datatype: date
    sql: ${TABLE}.dte_vente ;;
  }

  dimension: marge {
    type: number
    sql: ${TABLE}.marge ;;
  }

  dimension: montant {
    type: number
    sql: ${TABLE}.montant ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: quantite {
    type: number
    sql: ${TABLE}.quantite ;;
  }

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "n"
    description: "pour filtrer sur les magasins en dévise"
    type: date
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "n-1"
    description: "pour filtrer sur les magasins en dévise"
    type: date
  }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "n-2"
    description: "pour filtrer sur les magasins en dévise"
    type: date
  }

  filter: date_filter_3 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "n-3"
    description: "pour filtrer sur les magasins en dévise"
    type: date
  }



  ############## calcul des KPIs à la période sélectionnée au niveau du filtre  ############

  measure: sum_montant_select_filter {
    type: sum
    value_format_name: decimal_0
    label: "montant"
    description: "pour les magasins en dévises"
    sql: CASE
          WHEN {% condition date_filter %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${montant}
        END ;;
  }

  measure: sum_marge_select_filter {
    label: "Marge"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${marge}
        END ;;
  }

  measure: sum_nb_ticket_select_filter {
    label: "Nb clts"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${nb_ticket}
        END ;;
  }

  measure: sum_nb_jour_select_filter {
    label: "Nb jr"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${dte_vente_date}
        END ;;
  }

  measure: sum_qte_select_filter {
    label: "Qte"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${quantite}
        END ;;
  }

  measure: ecarts_jour_select_mois {
    label: "écart jr"
    type: number
    sql:  ${sum_nb_jour_select_filter}-${sum_nb_jour_select_filter_N1} ;;
  }


  ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



  measure: sum_montant_select_filter_N1 {
    type: sum
    value_format_name: decimal_0
    label: "montant n-1"
    description: "pour les magasins en dévises"
    sql: CASE
          WHEN {% condition date_filter_1 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${montant}
        END ;;
  }

  measure: sum_marge_select_filter_N1 {
    label: "Marge n-1"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_1 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${marge}
        END ;;
  }

  measure: sum_nb_ticket_select_filter_N1 {
    label: "Nb clts n-1"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_1 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${nb_ticket}
        END ;;
  }

  measure: sum_nb_jour_select_filter_N1 {
    label: "Nb jr n-1"
    description: "pour les magasins en dévises"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_1 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${dte_vente_date}
        END ;;
  }

  measure: sum_qte_select_filter_N1 {
    label: "Qte n-1"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_1 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${quantite}
        END ;;
  }



  ############## calcul des KPIs à n-2 de la période sélectionnée au niveau du filtre ##############


  measure: sum_montant_select_filter_N2 {
    type: sum
    value_format_name: decimal_0
    label: "montant n-2"
    description: "pour les magasins en dévises"
    sql: CASE
          WHEN {% condition date_filter_2 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${montant}
        END ;;
  }

  measure: sum_marge_select_filter_N2 {
    label: "Marge n-2"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_2 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${marge}
        END ;;
  }

  measure: sum_nb_ticket_select_filter_N2 {
    label: "Nb clts n-2"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_2 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${nb_ticket}
        END ;;
  }

  measure: sum_nb_jour_select_filter_N2 {
    label: "Nb jr n-2"
    description: "pour les magasins en dévises"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_2 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${dte_vente_date}
        END ;;
  }

  measure: sum_qte_select_filter_N2 {
    label: "Qte n-2"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_2 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${quantite}
        END ;;
  }


############## calcul des KPIs à n-2 de la période sélectionnée au niveau du filtre ##############


  measure: sum_montant_select_filter_N3 {
    type: sum
    value_format_name: decimal_0
    label: "montant n-3"
    description: "pour les magasins en dévises"
    sql: CASE
          WHEN {% condition date_filter_3 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${montant}
        END ;;
  }

  measure: sum_marge_select_filter_N3 {
    label: "Marge n-3"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_3 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${marge}
        END ;;
  }

  measure: sum_nb_ticket_select_filter_N3 {
    label: "Nb clts n-3"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_3 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${nb_ticket}
        END ;;
  }

  measure: sum_nb_jour_select_filter_N3 {
    label: "Nb jr n-3"
    description: "pour les magasins en dévises"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_3 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${dte_vente_date}
        END ;;
  }

  measure: sum_qte_select_filter_N3 {
    label: "Qte n-3"
    description: "pour les magasins en dévises"
    type: sum
    value_format_name: decimal_0
    sql: CASE
          WHEN {% condition date_filter_3 %} CAST(${dte_vente_date} AS TIMESTAMP)  {% endcondition %}
          THEN ${quantite}
        END ;;
  }

  ######### calcul des rapports entre les KPIs à la période n sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_filter {
    label: "clts / jour"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_filter}/NULLIF(${sum_nb_jour_select_filter},0) ;;
  }

  measure: ca_par_jour_select_filter {
    label: "CA / jour"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_montant_select_filter}/NULLIF(${sum_nb_jour_select_filter},0) ;;
  }

  measure: taux_de_marge_select_filter {
    label: "% marge"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_filter}/NULLIF(${sum_montant_select_filter},0);;
  }

  measure: panier_moyen_select_filter {
    label: "PM"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_montant_select_filter}/NULLIF(${sum_nb_ticket_select_filter},0) ;;
  }

  measure: marge_par_client_select_filter {
    label: "marge / clts"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_filter}/NULLIF(${sum_nb_ticket_select_filter},0) ;;
  }


  ######### calcul des rapports entre les KPIs à la période n-1 sélectionnée au niveau du filtre  ##########

  measure: client_par_jour_select_filter_N1 {
    label: "clts / jour n-1"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_filter_N1}/NULLIF(${sum_nb_jour_select_filter_N1},0) ;;
  }

  measure: ca_par_jour_select_filter_N1 {
    label: "CA / jour n-1"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_montant_select_filter_N1}/NULLIF(${sum_nb_jour_select_filter_N1},0) ;;
  }

  measure: taux_de_marge_select_filter_N1 {
    label: "% marge n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_filter_N1}/NULLIF(${sum_montant_select_filter_N1},0);;
  }

  measure: panier_moyen_select_filter_N1{
    label: "PM n-1"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_montant_select_filter_N1}/NULLIF(${sum_nb_ticket_select_filter_N1},0) ;;
  }

  measure: marge_par_client_select_filter_N1 {
    label: "marge / clts n-1"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_filter_N1}/NULLIF(${sum_nb_ticket_select_filter_N1},0) ;;
  }



  ######### calcul des rapports entre les KPIs à la période n-2 sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_filter_N2 {
    label: "clts / jour n-2"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_filter_N2}/NULLIF(${sum_nb_jour_select_filter_N2},0) ;;
  }

  measure: ca_par_jour_select_filter_N2 {
    label: "CA / jour n-2"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_montant_select_filter_N2}/NULLIF(${sum_nb_jour_select_filter_N2},0) ;;
  }

  measure: taux_de_marge_select_filter_N2 {
    label: "% marge n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_filter_N2}/NULLIF(${sum_montant_select_filter_N2},0);;
  }

  measure: panier_moyen_select_filter_N2{
    label: "PM n-2"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_montant_select_filter_N2}_select_mois}/NULLIF(${sum_nb_ticket_select_filter_N2},0) ;;
  }

  measure: marge_par_client_select_filter_N2 {
    label: "marge / clts n-2"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_filter_N2}/NULLIF(${sum_nb_ticket_select_filter_N2},0) ;;
  }



######### calcul des rapports entre les KPIs à la période n-3 sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_filter_N3 {
    label: "clts / jour n-3"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_filter_N3}/NULLIF(${sum_nb_jour_select_filter_N3},0) ;;
  }

  measure: ca_par_jour_select_filter_N3{
    label: "CA / jour n-3"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_montant_select_filter_N3}/NULLIF(${sum_nb_jour_select_filter_N3},0) ;;
  }

  measure: taux_de_marge_select_filter_N3 {
    label: "% marge n-3"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_filter_N3}/NULLIF(${sum_montant_select_filter_N3},0);;
  }

  measure: panier_moyen_select_filter_N3{
    label: "PM n-3"
    description: "pour les magasins en dévises"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_montant_select_filter_N3}_select_mois}/NULLIF(${sum_nb_ticket_select_filter_N3},0) ;;
  }

  measure: marge_par_client_select_filter_N3 {
    label: "marge / clts n-3"
    description: "pour les magasins en dévises"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_filter_N3}/NULLIF(${sum_nb_ticket_select_filter_N3},0) ;;
  }


  ########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_filter {
    label: "prog CA"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_montant_select_filter}-${sum_montant_select_filter_N1})/NULLIF(${sum_montant_select_filter_N1},0);;
  }

  measure: prog_marge_select_filter {
    label: "prog marge"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_filter}-${sum_marge_select_filter_N1})/NULLIF(${sum_marge_select_filter_N1},0);;
  }

  measure: prog_taux_marge_select_filter {
    label: "prog %marge"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_filter}-${taux_de_marge_select_filter_N1})/NULLIF(${taux_de_marge_select_filter_N1},0);;
  }


  measure: prog_Clients_select_filter {
    label: "prog clts/jr"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_filter}-${client_par_jour_select_filter_N1})/NULLIF(${client_par_jour_select_filter_N1},0) ;;
  }

  measure: prog_nb_Clients_select_filter {
    label: "prog nb clts"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_filter}-${sum_nb_ticket_select_filter_N1})/NULLIF(${sum_nb_ticket_select_filter_N1},0) ;;
  }

  measure: prog_ca_jour_select_filter {
    label: "prog CA / jr"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_filter}-${ca_par_jour_select_filter_N1})/NULLIF(${ca_par_jour_select_filter_N1},0) ;;
  }

  measure: prog_PM_select_filter {
    label: "prog PM"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_filter}-${panier_moyen_select_filter_N1})/(NULLIF(${panier_moyen_select_filter_N1},0));;
  }

  measure: prog_marge_client_select_filter {
    label: "prog marge/clt"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_filter}-${marge_par_client_select_filter_N1})/NULLIF(${marge_par_client_select_filter_N1},0);;
  }



  ######### Calcul des progressions n-1 vs n-2 à la péridode sélectionée au niveau du filtre #########

  measure:prog_ca_select_mois_N1 {
    label: "prog CA n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_montant_select_filter_N1}-${sum_montant_select_filter_N2})/NULLIF(${sum_montant_select_filter_N2},0);;
  }

  measure: prog_marge_select_mois_N1 {
    label: "prog marge n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_filter_N1}-${sum_marge_select_filter_N2})/NULLIF(${sum_marge_select_filter_N2},0);;
  }

  measure: prog_nb_Clients_select_mois_N1 {
    label: "prog nb clts n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_filter_N1}-${sum_nb_ticket_select_filter_N2})/NULLIF(${sum_nb_ticket_select_filter_N2},0) ;;
  }

  measure: prog_taux_marge_select_mois_N1 {
    label: "prog %marge n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_filter_N1}-${taux_de_marge_select_filter_N2})/NULLIF(${taux_de_marge_select_filter_N2},0);;
  }

  measure: prog_Clients_select_mois_N1 {
    label: "prog clts/jr n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_filter_N1}-${client_par_jour_select_filter_N2})/NULLIF(${client_par_jour_select_filter_N2},0) ;;
  }

  measure: prog_ca_jour_select_mois_N1 {
    label: "prog CA/jr n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_filter_N1}-${ca_par_jour_select_filter_N2})/NULLIF(${ca_par_jour_select_filter_N2},0) ;;
  }

  measure: prog_PM_select_mois_N1 {
    label: "prog PM n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_filter_N1}-${panier_moyen_select_filter_N2})/(NULLIF(${panier_moyen_select_filter_N2},0));;
  }

  measure: prog_marge_client_select_mois_N1 {
    label: "prog marge/clt n-1"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_filter_N1}-${marge_par_client_select_filter_N2})/NULLIF(${marge_par_client_select_filter_N2},0);;
  }


######### Calcul des progressions n-2 vs n-3 à la péridode sélectionée au niveau du filtre #########

  measure:prog_ca_select_mois_N2 {
    label: "prog CA n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_montant_select_filter_N2}-${sum_montant_select_filter_N3})/NULLIF(${sum_montant_select_filter_N3},0);;
  }

  measure: prog_marge_select_mois_N2 {
    label: "prog marge n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_filter_N2}-${sum_marge_select_filter_N3})/NULLIF(${sum_marge_select_filter_N3},0);;
  }

  measure: prog_taux_marge_select_mois_N2 {
    label: "prog %marge n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_filter_N2}-${taux_de_marge_select_filter_N3})/NULLIF(${taux_de_marge_select_filter_N3},0);;
  }

  measure: prog_Clients_select_mois_N2 {
    label: "prog clts/jr n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_filter_N2}-${client_par_jour_select_filter_N3})/NULLIF(${client_par_jour_select_filter_N3},0) ;;
  }

  measure: prog_nb_Clients_select_mois_N3 {
    label: "prog nb clts n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_filter_N2}-${sum_nb_ticket_select_filter_N3})/NULLIF(${sum_nb_ticket_select_filter_N3},0) ;;
  }

  measure: prog_ca_jour_select_mois_N2 {
    label: "prog CA/jr n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_filter_N2}-${ca_par_jour_select_filter_N3})/NULLIF(${ca_par_jour_select_filter_N3},0) ;;
  }

  measure: prog_PM_select_mois_N2 {
    label: "prog PM n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_filter_N2}-${panier_moyen_select_filter_N3})/(NULLIF(${panier_moyen_select_filter_N3},0));;
  }

  measure: prog_marge_client_select_mois_N2 {
    label: "prog marge/clt n-2"
    description: "pour les magasins en dévises"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_filter_N2}-${marge_par_client_select_filter_N3})/NULLIF(${marge_par_client_select_filter_N3},0);;
  }
}
