view: sql_runner_query {
  derived_table: {
    sql: select distinct
        m.Animateur as Animateur ,
        m.DATE_OUV as Dte_Ouverture,
        m.Directeur as Directeur ,
        m.Franchise as Franchise ,
        m.Nom_TBE as NOM,
        m.Type_TBE as Typ ,
        m.Pays_TBE as Pays ,
        m.Region as Region ,
        m.SURF_VTE as Surface ,
        m.TYP_MAG as TYP_MAG,
        m.Tranche_age as Anciennete,
        m.CD_Magasin as CD_Magasin ,
        v.CD_Site_Ext as CD_Site_Ext ,
        v.Dte_Vte as Dte_Vte ,
        v.Typ_Vente as Typ_Vente ,
        v.Val_Achat_Gbl as Val_Achat_Gbl,
        v.Qtite as Qtite,
        v.ca_ht as ca_ht,
        v.marge_brute as marge_brute,
        mag.nb_ticket as nb_ticket,
        c.nbre_commande as nbre_commande,
        c.Total_HT as Total_HT

        from `bv-prod.Matillion_Perm_Table.Magasins` m

        LEFT JOIN

        (select
                CD_Site_Ext ,
                Dte_Vte ,
                Typ_Vente ,
                sum(Val_Achat_Gbl) as Val_Achat_Gbl ,
                sum(Qtite) as Qtite ,
                sum(ca_ht) as ca_ht ,
                sum(marge_brute) as marge_brute
          from `bv-prod.Matillion_Perm_Table.TF_VENTE`
          group by 1,2,3

      UNION ALL

        select
              CD_SITE_EXT ,
              DTE_VENTE ,
              TYP_VENTE ,
              sum(VAL_ACHAT_GBL) as Val_Achat_Gbl ,
              sum(QTITE) as Qtite ,
              sum(CA_HT) as ca_ht ,
              sum(MARGE_BRUTE) as marge_brute
          from `bv-prod.Matillion_Perm_Table.GOOGLE_SHEET`
          group by 1,2,3

        ) v


          ON  m.CD_Logiciel = v.CD_Site_Ext


        LEFT JOIN


        (select
                CD_Site_Ext,
                Dte_Vte,
                Typ_vente,
                sum(nb_ticket) as nb_ticket
              from `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
              group by 1,2,3
          ) mag


        ON mag.CD_Site_Ext = v.CD_Site_Ext AND mag.Dte_Vte = v.Dte_Vte AND v.Typ_vente = mag.Typ_vente


       LEFT JOIN

       (SELECT
              cd_magasin,
              CAST(DATETIME_TRUNC(dte_commande, DAY) AS DATE) AS dte_cde,
              count(distinct(cd_commande)) as Nbre_commande ,
              sum(Total_HT) as Total_HT
            FROM `bv-prod.Matillion_Perm_Table.COMMANDES`
            group by 1,2
        ) as c


          ON c.cd_magasin = m.CD_Magasin AND  c.dte_cde = v.Dte_Vte



 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: dte_ouverture {
    type: date
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
  }

  dimension: directeur {
    type: string
    sql: ${TABLE}.Directeur ;;
  }

  dimension: franchise {
    type: string
    sql: ${TABLE}.Franchise ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: typ {
    type: string
    sql: ${TABLE}.Typ ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [date, raw]
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.nbre_commande ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  set: detail {
    fields: [
      animateur,
      dte_ouverture,
      directeur,
      franchise,
      nom,
      typ,
      pays,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      cd_site_ext,
      typ_vente,
      val_achat_gbl,
      qtite,
      ca_ht,
      marge_brute,
      nb_ticket,
      nbre_commande,
      total_ht
    ]
  }
}
