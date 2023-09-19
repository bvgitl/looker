view: pdt_famille {
  derived_table: {
    sql:
WITH Vente AS
(
    SELECT
        CD_Magasin,
        Dte_Vte,
        Typ_Vente,
        CD_Article,
        CD_Article_Original,
        /*EXTRACT(YEAR FROM Dte_Vte) AS Year,*/
        CAST(FORMAT_DATE("%G", Dte_Vte) AS INT) AS Year,
        CAST(FORMAT_DATE("%V", Dte_Vte) AS INT) AS WeekNumber,
        FORMAT_DATE("%w", Dte_Vte) AS WeekDayNumber,
        sum(Val_Achat_Gbl) as Val_Achat_Gbl,
        sum(Qtite) as Qtite,
        sum(ca_ht) as ca_ht,
        sum(marge_brute) as marge_brute,
        MAX(StatutBcp) AS StatutBcp,
        MIN(StatutGoogleSheet) AS StatutGoogleSheet
    FROM
    (
        SELECT
            CD_Magasin,
            Dte_Vte,
            Typ_Vente,
            CD_Article,
            CD_Article_Original,
            Val_Achat_Gbl,
            Qtite,
            ca_ht,
            marge_brute,
            'BCP reçu' AS StatutBcp,
            'GoogleSheet vierge' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Perm_Table.TF_VENTE`
        UNION ALL
        SELECT
            CODE_ACTEUR as CD_Magasin,
            DTE_VENTE,
            TYP_VENTE,
            COALESCE(ID_ARTICLE, '0') AS ID_ARTICLE,
            COALESCE(ID_ARTICLE, '0') AS CD_Article_Original,
            VAL_ACHAT_GBL as Val_Achat_Gbl,
            QTITE as Qtite ,
            CA_HT as ca_ht,
            MARGE_BRUTE as marge_brute,
            'BCP non reçu' AS StatutBcp,
            'GoogleSheet renseignée' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET`
        UNION ALL
        SELECT
            mf.CodeMagasinActeur AS CD_Magasin,
            mf.DateFichier AS DTE_VENTE,
            0 AS TYP_VENTE,
            '0' AS ID_ARTICLE,
            '0' AS CD_Article_Original,
            null AS Val_Achat_Gbl,
            null AS Qtite,
            null AS ca_ht,
            null AS marge_brute,
            'BCP non reçu' AS StatutBcp,
            'GoogleSheet vierge' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Monitoring.MonitoringFichier` mf
        WHERE mf.Flux = 'BCP10_BCP13'
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.TF_VENTE` tf
            WHERE tf.CD_Magasin = mf.CodeMagasinActeur
            AND tf.Dte_Vte = mf.DateFichier
        )
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET` gs
            WHERE gs.CODE_ACTEUR = mf.CodeMagasinActeur
            AND gs.DTE_VENTE = mf.DateFichier
        )
    )
    GROUP BY 1,2,3,4,5
),
AllDateVente AS
(
    SELECT DISTINCT
        mf.DateFichier AS Dte_Vte,
        /*EXTRACT(YEAR FROM mf.DateFichier) AS Year,*/
        CAST(FORMAT_DATE("%G", mf.DateFichier) AS INT) AS Year,
        CAST(FORMAT_DATE("%V", mf.DateFichier) AS INT) AS WeekNumber,
        FORMAT_DATE("%w", mf.DateFichier) AS WeekDayNumber
    FROM `bv-prod.Matillion_Monitoring.MonitoringFichier` mf
    WHERE mf.Flux = 'BCP10_BCP13'
),
AllVenteArticle AS -- Construire la liste des Magasins x Articles pour les 4 ans
( -- On "projette" les articles vendus pour SN-1/SN-2/SN-3 sur la date courante
    -- Articles de semaine N
    SELECT DISTINCT
        v_sn0.CD_Magasin,
        v_sn0.Dte_Vte,
        v_sn0.Typ_Vente,
        v_sn0.CD_Article,
        v_sn0.CD_Article_Original,
        v_sn0.Year,
        v_sn0.WeekNumber,
        v_sn0.WeekDayNumber
    FROM Vente v_sn0

    UNION DISTINCT-- Articles de Semaine N-1
    SELECT DISTINCT
        v_sn1.CD_Magasin,
        a.Dte_Vte,
        v_sn1.Typ_Vente,
        v_sn1.CD_Article,
        v_sn1.CD_Article_Original,
        a.Year,
        a.WeekNumber,
        a.WeekDayNumber
    FROM AllDateVente a
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms1 ON ms1.Annee_N = a.Year AND ms1.Semaine_N = a.WeekNumber
    INNER JOIN Vente v_sn1
      ON  v_sn1.Year = ms1.Annee_N1
      AND v_sn1.WeekNumber = ms1.Semaine_N1
      AND v_sn1.WeekDayNumber = a.WeekDayNumber

    UNION DISTINCT -- Articles de Semaine N-2
    SELECT DISTINCT
        v_sn2.CD_Magasin,
        a.Dte_Vte,
        v_sn2.Typ_Vente,
        v_sn2.CD_Article,
        v_sn2.CD_Article_Original,
        a.Year,
        a.WeekNumber,
        a.WeekDayNumber
    FROM AllDateVente a
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms1 ON ms1.Annee_N = a.Year AND ms1.Semaine_N = a.WeekNumber
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms2 ON ms2.Annee_N = ms1.Annee_N1 AND ms2.Semaine_N = ms1.Semaine_N1
    INNER JOIN Vente v_sn2
      ON  v_sn2.Year = ms2.Annee_N1
      AND v_sn2.WeekNumber = ms2.Semaine_N1
      AND v_sn2.WeekDayNumber = a.WeekDayNumber

    UNION DISTINCT -- Articles de Semaine N-3
    SELECT DISTINCT
        v_sn3.CD_Magasin,
        a.Dte_Vte,
        v_sn3.Typ_Vente,
        v_sn3.CD_Article,
        v_sn3.CD_Article_Original,
        a.Year,
        a.WeekNumber,
        a.WeekDayNumber
    FROM AllDateVente a
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms1 ON ms1.Annee_N = a.Year AND ms1.Semaine_N = a.WeekNumber
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms2 ON ms2.Annee_N = ms1.Annee_N1 AND ms2.Semaine_N = ms1.Semaine_N1
    INNER JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms3 ON ms3.Annee_N = ms2.Annee_N1 AND ms3.Semaine_N = ms2.Semaine_N1
    INNER JOIN Vente v_sn3
      ON  v_sn3.Year = ms3.Annee_N1
      AND v_sn3.WeekNumber = ms3.Semaine_N1
      AND v_sn3.WeekDayNumber = a.WeekDayNumber
),
AllVente AS
(
    SELECT
        a.CD_Magasin,
        a.Dte_Vte,
        a.Typ_Vente,
        a.CD_Article,
        a.CD_Article_Original,
        a.Year,
        a.WeekNumber,
        a.WeekDayNumber,
        COALESCE(v_sn0.StatutBcp, 'BCP non reçu') AS StatutBcp,
        COALESCE(v_sn0.StatutGoogleSheet, 'GoogleSheet vierge') AS StatutGoogleSheet,

        v_sn0.Val_Achat_Gbl as Val_Achat_Gbl,
        v_sn0.Qtite as Qtite,
        v_sn0.ca_ht as ca_ht,
        v_sn0.marge_brute as marge_brute,

        v_sn1.Val_Achat_Gbl as Val_Achat_Gbl_sn1,
        v_sn1.Qtite as Qtite_sn1,
        v_sn1.ca_ht as ca_ht_sn1,
        v_sn1.marge_brute as marge_brute_sn1,

        v_sn2.Val_Achat_Gbl as Val_Achat_Gbl_sn2,
        v_sn2.Qtite as Qtite_sn2,
        v_sn2.ca_ht as ca_ht_sn2,
        v_sn2.marge_brute as marge_brute_sn2,

        v_sn3.Val_Achat_Gbl as Val_Achat_Gbl_sn3,
        v_sn3.Qtite as Qtite_sn3,
        v_sn3.ca_ht as ca_ht_sn3,
        v_sn3.marge_brute as marge_brute_sn3

    FROM AllVenteArticle a
    LEFT JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms1 ON ms1.Annee_N = a.Year AND ms1.Semaine_N = a.WeekNumber
    LEFT JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms2 ON ms2.Annee_N = ms1.Annee_N1 AND ms2.Semaine_N = ms1.Semaine_N1
    LEFT JOIN `bv-prod.Matillion_Perm_Table.MAPPING_SEMAINE` ms3 ON ms3.Annee_N = ms2.Annee_N1 AND ms3.Semaine_N = ms2.Semaine_N1
    LEFT JOIN Vente v_sn0
      ON  v_sn0.CD_Magasin = a.CD_Magasin
      AND v_sn0.Typ_Vente = a.Typ_Vente
      AND v_sn0.CD_Article = a.CD_Article
      AND v_sn0.CD_Article_Original = a.CD_Article_Original
      AND v_sn0.Dte_Vte = a.Dte_Vte
    LEFT JOIN Vente v_sn1
      ON  v_sn1.CD_Magasin = a.CD_Magasin
      AND v_sn1.Typ_Vente = a.Typ_Vente
      AND v_sn1.CD_Article = a.CD_Article
      AND v_sn1.CD_Article_Original = a.CD_Article_Original
      AND v_sn1.Year = ms1.Annee_N1
      AND v_sn1.WeekNumber = ms1.Semaine_N1
      AND v_sn1.WeekDayNumber = a.WeekDayNumber
    LEFT JOIN Vente v_sn2
      ON  v_sn2.CD_Magasin = a.CD_Magasin
      AND v_sn2.Typ_Vente = a.Typ_Vente
      AND v_sn2.CD_Article = a.CD_Article
      AND v_sn2.CD_Article_Original = a.CD_Article_Original
      AND v_sn2.Year = ms2.Annee_N1
      AND v_sn2.WeekNumber = ms2.Semaine_N1
      AND v_sn2.WeekDayNumber = a.WeekDayNumber
    LEFT JOIN Vente v_sn3
      ON  v_sn3.CD_Magasin = a.CD_Magasin
      AND v_sn3.Typ_Vente = a.Typ_Vente
      AND v_sn3.CD_Article = a.CD_Article
      AND v_sn3.CD_Article_Original = a.CD_Article_Original
      AND v_sn3.Year = ms3.Annee_N1
      AND v_sn3.WeekNumber = ms3.Semaine_N1
      AND v_sn3.WeekDayNumber = a.WeekDayNumber
)
SELECT DISTINCT
    a.l_Article_long as designation,
    a.c_Type  as Typ_article,
    a.c_Note as Note_ecologique,
    a.c_Gencode as Gencode,
    a.c_Validite_1 as Statut_article,
    a.c_Origine as Origine,
    arb.N4 as Niveau_4,
    arb.N3_SousFamille as N3_SS_Famille,
    arb.N2_Famille as N2_Famille,
    arb.N1_Division as N1_Division,
    m.Nom_TBE as NOM,
    m.Type_TBE as Typ ,
    m.DATE_OUV as Dte_Ouverture,
    m.Pays_TBE as Pays ,
    m.PAYS AS Territoire,
    m.Directeur AS Directeur,
    m.Animateur as Animateur,
    m.Region as Region ,
    m.SURF_VTE as Surface ,
    m.TYP_MAG as TYP_MAG,
    m.Tranche_age as Anciennete,
    m.CD_Magasin as CD_Magasin,
    m.CD_Logiciel as CD_Logiciel,
    m.Latitude,
    m.Longitude,
    m.Code_postal,
    m.Ville,
    m2.Nom_TBE as NOM_histo,
    m2.Type_TBE as Typ_histo,
    m2.DATE_OUV as Dte_Ouverture_histo,
    m2.Pays_TBE as Pays_histo ,
    m2.PAYS AS Territoire_histo,
    m2.Directeur AS Directeur_histo,
    m2.Animateur as Animateur_histo,
    m2.Region as Region_histo ,
    m2.SURF_VTE as Surface_histo ,
    m2.TYP_MAG as TYP_MAG_histo,
    m2.Tranche_age as Anciennete_histo,
    m2.Latitude as Latitude_histo,
    m2.Longitude as Longitude_histo,
    m2.Code_postal as Code_Postal_histo,
    m2.Ville as Ville_histo,
    v.CD_Article as Article,
    v.CD_Article_Original AS ArticleOriginal,
    v.Typ_Vente as Typ_Vente,
    v.Dte_Vte as Dte_Vte,
    v.StatutBcp,
    v.StatutGoogleSheet,
    mq.LB_MARQUE as Marque,
    f.l_Fournisseur as Fournisseur,
    a.c_fournisseur as Code_Fournisseur,
    a.c_Reference_fournisseur  as Ref_Fournisseur,
    s.n_stock as stock,
    w.Nbre_commande as Nbre_commande,
    w.Quantite_commandee as Quantite_commandee,
    w.Tarif_Produit_HT as Tarif_Produit_HT,

    v.Val_Achat_Gbl,
    v.Qtite,
    v.ca_ht,
    v.marge_brute,

    v.Val_Achat_Gbl_sn1,
    v.Qtite_sn1,
    v.ca_ht_sn1,
    v.marge_brute_sn1,

    v.Val_Achat_Gbl_sn2,
    v.Qtite_sn2,
    v.ca_ht_sn2,
    v.marge_brute_sn2,

    v.Val_Achat_Gbl_sn3,
    v.Qtite_sn3,
    v.ca_ht_sn3,
    v.marge_brute_sn3,

    m.Enseigne as Enseigne

FROM AllVente v
LEFT JOIN `bv-prod.Matillion_Perm_Table.Magasins` m ON m.CD_Magasin = v.CD_Magasin
LEFT JOIN `bv-prod.Matillion_Perm_Table.Magasins_Histo` m2 ON v.CD_Magasin = m2.CD_Magasin AND m2.ScdDateDebut <= v.Dte_vte AND v.Dte_vte < m2.ScdDateFin
LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_DWH` a ON a.c_Article = v.CD_Article
LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE` arb ON arb.CodeArticle = v.CD_Article
LEFT JOIN `bv-prod.Matillion_Perm_Table.Marques` mq ON a.c_Marque = mq.cd_marque
LEFT JOIN `bv-prod.Matillion_Perm_Table.FOUR_DWH` f ON   a.c_Fournisseur = f.c_fournisseur
LEFT JOIN `bv-prod.Matillion_Perm_Table.Stock_DWH_Histo` s
    ON  s.cd_acteur = v.CD_Magasin
    AND CAST(s.cd_article AS STRING) = v.CD_Article
    AND s.ScdDateDebut <= v.Dte_vte AND v.Dte_vte < s.ScdDateFin
    AND v.Typ_Vente = 0
FULL JOIN
(
    SELECT
      p.ProductId as cd_produit,
      c.CdMagasin as cd_magasin,
      CAST(DATETIME_TRUNC(DATETIME(c.DateCommande), DAY) AS DATE) AS dte_cde,
      count(distinct(p.CdCommande)) as Nbre_commande ,
      sum(p.Quantite) as Quantite_commandee,
      sum(p.Tarif_Produit_HT) as Tarif_Produit_HT
      FROM `bv-prod.Matillion_Perm_Table.Web_Inter_Produit_Commande` p
      INNER JOIN  `bv-prod.Matillion_Perm_Table.Web_Inter_Commande` c
      ON p.CdCommande = c.CdCommande
      group by 1,2,3
) w
    ON  w.cd_produit = v.CD_Article
    AND w.dte_cde = v.Dte_vte
    AND w.cd_magasin = v.CD_Magasin
    AND v.Typ_Vente = 0

 ;;

    persist_for: "2 hours"
  }


  dimension: designation {
    type: string
    sql: ${TABLE}.designation ;;
    view_label: "Article"
  }

  dimension: typ_article {
    type: string
    sql: ${TABLE}.Typ_article ;;
    view_label: "Article"
  }

  dimension: gencode {
    type: string
    sql: ${TABLE}.Gencode ;;
    view_label: "Article"
  }

  dimension: niveau_4 {
    type: string
    sql: ${TABLE}.Niveau_4 ;;
    view_label: "N4"
  }

  dimension: n3_ss_famille {
    type: string
    sql: ${TABLE}.N3_SS_Famille ;;
    view_label: "N3"
  }

  dimension: n2_famille {
    type: string
    sql: ${TABLE}.N2_Famille ;;
    view_label: "N2"
  }

  dimension: n1_division {
    type: string
    sql: ${TABLE}.N1_Division ;;
    view_label: "N1"
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
    label : "Nom"
    view_label: "Magasins (actuel)"
  }

  dimension: typ {
    type: string
    sql: ${TABLE}.Typ ;;
    label : "Type"
    view_label: "Magasins (actuel)"
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
    label : "Pays"
    view_label: "Magasins (actuel)"
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
    label : "Animateur"
    view_label: "Magasins (actuel)"
  }

  dimension: directeur {
    type: string
    sql: ${TABLE}.Directeur ;;
    label : "Directeur"
    view_label: "Magasins (actuel)"
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
    label : "Région"
    view_label: "Magasins (actuel)"
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
    label : "Surface"
    view_label: "Magasins (actuel)"
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
    label : "Type Magasin"
    view_label: "Magasins (actuel)"
  }

  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
    label : "Ancienneté"
    view_label: "Magasins (actuel)"
  }

  dimension: Latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
    label : "Latitude"
    view_label: "Magasins (actuel)"
  }

  dimension: Longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
    label : "Longitude"
    view_label: "Magasins (actuel)"
  }

  dimension: Emplacement {
    type: location
    sql_latitude:${Latitude} ;;
    sql_longitude:${Longitude} ;;
    label : "Emplacement"
    view_label: "Magasins (actuel)"
  }


  dimension: nom_histo {
    type: string
    sql: ${TABLE}.NOM_histo ;;
    label : "Nom (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: typ_histo {
    type: string
    sql: ${TABLE}.Typ_histo ;;
    label: "Type (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: pays_histo {
    type: string
    sql: ${TABLE}.Pays_histo ;;
    label: "Pays (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: animateur_histo {
    type: string
    sql: ${TABLE}.Animateur_histo ;;
    label: "Animateur (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: directeur_histo {
    type: string
    sql: ${TABLE}.Directeur_histo ;;
    label : "Directeur (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: region_histo {
    type: string
    sql: ${TABLE}.Region_histo ;;
    label: "Région (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: surface_histo {
    type: number
    sql: ${TABLE}.Surface_histo ;;
    label: "Surface (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: typ_mag_histo {
    type: string
    sql: ${TABLE}.TYP_MAG_histo ;;
    label: "Type Magasin (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: anciennete_histo {
    type: string
    sql: ${TABLE}.Anciennete_histo ;;
    label: "Ancienneté (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Latitude_histo {
    type: string
    sql: ${TABLE}.Latitude_histo ;;
    label: "Latitude (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Longitude_histo {
    type: string
    sql: ${TABLE}.Longitude_histo ;;
    label: " Longitude (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Emplacement_histo {
    type: location
    sql_latitude:${Latitude_histo} ;;
    sql_longitude:${Longitude_histo} ;;
    label: "Emplacement (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    view_label: "Magasins (actuel)"
  }

  dimension: cd_logiciel {
    type: string
    sql: ${TABLE}.CD_Logiciel ;;
    view_label: "Magasins (actuel)"
    label: "Code Externe Magasin"
  }

  dimension: article {
    type: string
    sql: ${TABLE}.Article ;;
    view_label: "Article"
    label: "Code Article"
  }

  dimension: article_original {
    type: string
    sql: ${TABLE}.ArticleOriginal ;;
    view_label: "Article"
    label: "Code Article Original"
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
    view_label: "Ventes"
  }

  dimension: enseigne {
    type: string
    sql: ${TABLE}.Enseigne ;;
    view_label: "Magasins (actuel)"
  }

  dimension: pays_vente {
    type: string
    sql:
    CASE ${TABLE}.Territoire
  WHEN 'FR-GUF' THEN 'Guyane'
  WHEN 'BE' THEN 'Belgique'
  WHEN 'CM' THEN 'Cameroun'
  WHEN 'ES' THEN 'Espagne'
  WHEN 'FR' THEN 'France métropole'
  WHEN 'FR-LRE' THEN 'La Réunion'
  WHEN 'FR-MAY' THEN 'Mayotte'
  WHEN 'FR-MF' THEN 'St Martin'
  WHEN 'FR-NC' THEN 'Nouvelle Calédonie'
  WHEN 'FR-GUF' THEN 'Guyane'
  WHEN 'MQ' THEN 'Martinique'
  WHEN 'MU' THEN 'Maurice'
  WHEN 'TN' THEN 'Tunisie'
  WHEN 'IT' THEN 'Italie'
  WHEN 'GP' THEN 'Guadeloupe'
  WHEN 'MT' THEN 'Malte'
    ELSE ${TABLE}.Territoire
  END
;;
    label: "Territoire"
    view_label: "Magasins (actuel)"
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
    view_label: "Ventes"
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
    view_label: "Ventes"
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
    view_label: "Ventes"
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
    view_label: "Ventes"
  }

  dimension: marque {
    type: string
    sql: ${TABLE}.Marque ;;
    view_label: "Marque"
  }

  dimension: fournisseur {
    type: string
    sql: ${TABLE}.Fournisseur ;;
    view_label: "Fournisseur"
  }

  dimension: stock {
    type: number
    sql: ${TABLE}.stock ;;
    view_label: "Stocks"
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.Nbre_commande ;;
    view_label: "Web"
  }

  dimension: quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
    view_label: "Web"
  }

  dimension: tarif_produit_ht {
    type: number
    sql: ${TABLE}.Tarif_Produit_HT ;;
    view_label: "Web"
  }

  dimension: Code_Fournisseur {
    type: string
    sql: ${TABLE}.Code_Fournisseur ;;
    view_label: "Article"
    label: "Code Fournisseur"
  }

  dimension: Ref_Fournisseur {
    type: string
    sql: ${TABLE}.Ref_Fournisseur ;;
    view_label: "Article"
    label: "Référence Fournisseur"
  }

  dimension: Ville {
    type: string
    sql: ${TABLE}.Ville ;;
    view_label: "Magasins (actuel)"
    label: "Ville Magasin"
  }

  dimension: Code_Postal {
    type: string
    sql: ${TABLE}.Code_Postal ;;
    view_label: "Magasins (actuel)"
    label: "Code Postal Magasin"
  }

  dimension: Ville_histo {
    type: string
    sql: ${TABLE}.Ville_histo ;;
    view_label: "Magasins (à date de vente)"
    label: "Ville histo Magasin"
  }

  dimension: Code_Postal_histo {
    type: string
    sql: ${TABLE}.Code_Postal_histo ;;
    view_label: "Magasins (à date de vente)"
    label: "Code Postal histo Magasin"
  }

  set: detail {
    fields: [
      designation,
      statut_article,
      typ_article,
      note_ecologique,
      gencode,
      niveau_4,
      n3_ss_famille,
      n2_famille,
      n1_division,
      nom,
      typ,
      pays,
      animateur,
      region,
      surface,
      typ_mag,
      anciennete,
      cd_magasin,
      article,
      article_original,
      typ_vente,
      qtite,
      ca_ht,
      marge_brute,
      marque,
      fournisseur,
      stock
    ]
  }


  dimension: note_ecologique {
    type: string
    sql: ${TABLE}.Note_ecologique ;;
    html: {% if value == "B" %}
          <p style="color: black; background-color: lime; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "C" %}
          <p style="color: black;  background-color: yellow; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "A" %}
          <p style="color: black; background-color: limegreen; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "D" %}
          <p style="color: black; background-color: gold; font-size: 100%;"><B>{{ value }}</B></p>
          {% elsif value == "X" %}
          <p style="color: black; background-color: red; font-size: 100%;"><B>{{ value }}</B></p>
          {% else %}
          <p style="color: black; background-color: tomato; font-size: 100%;"><B>{{ value }}</B></p>
    {% endif %};;
    view_label: "Article"
  }

  dimension: origine {
    type: string
    sql: CASE
          WHEN ${TABLE}.Origine = 5 THEN "France"
          WHEN ${TABLE}.Origine = 6 THEN "Union Européenne"
          WHEN ${TABLE}.Origine = 7 THEN "Reste du monde"
          WHEN ${TABLE}.Origine = 8 THEN "Non renseigné"
          END;;
    view_label: "Article"
  }

  dimension: statut_article {
    type: string
    sql: CASE
          WHEN ${TABLE}.Statut_article = 0 THEN "Création"
          WHEN ${TABLE}.Statut_article = 1 THEN "Actif"
          WHEN ${TABLE}.Statut_article = 5 THEN "Déréférencé"
          END;;
    view_label: "Article"
  }


  dimension_group: dte_ouverture {
    type: time
    timeframes: [
      raw,
      date,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
    label: "Date Ouverture"
    view_label: "Magasins (actuel)"
  }

  dimension_group: dte_ouverture_histo {
    type: time
    timeframes: [
      raw,
      date,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Ouverture_histo ;;
    label: "Date Ouverture (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw, date, week, month, month_name, quarter, year,
      fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
    view_label: "Ventes"
  }




  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n"
    type: date
    view_label: "Ventes"
    group_label: "Année N"
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-1"
    type: date
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-2"
    type: date
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  dimension: categorie {
    label: "Catégorie"
    sql:
        CASE
          WHEN ${typ} = "S"  OR
          ${dte_ouverture_date} > CAST ({% date_start date_filter_1 %} AS DATETIME) THEN "P. non Comparable"
          WHEN ${dte_ouverture_date} <= CAST ({% date_start date_filter_1 %} AS DATETIME) THEN "P.Comparable"
        END
    ;;
    view_label: "Ventes"
  }


  dimension: Type_retrocession {
    sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            ELSE "Rétrocession"
          END ;;
    view_label: "Ventes"
  }

  dimension: statut_bcp {
    type: string
    sql: ${TABLE}.StatutBcp ;;
    label: "Statut BCP"
    view_label: "Ventes"
  }

  dimension: statut_google_sheet {
    type: string
    sql: ${TABLE}.StatutGoogleSheet ;;
    label: "Statut GoogleSheet"
    view_label: "Ventes"
  }


  dimension: Groupe_Region {
    sql: CASE
            WHEN ${region} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW", "IDF", "RS") THEN "France Metro"
            WHEN ${region} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    label: "Groupe Région"
    view_label: "Magasins (actuel)"
  }

  dimension: Type_MEP {
    sql: CASE
            WHEN ${typ} IN ("I","Cyi") THEN "MEP"
          END ;;
    label: "Type MEP"
    view_label: "Magasins (actuel)"
  }

  dimension: Type_City {
    sql: CASE
            WHEN ${typ} IN ("Cyi", "Cyf") THEN "City"
          END ;;
    label: "Type City"
    view_label: "Magasins (actuel)"
  }


  dimension: Groupe_Region_histo {
    sql: CASE
            WHEN ${region_histo} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW", "IDF", "RS") THEN "France Metro"
            WHEN ${region_histo} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    label: "Groupe Région (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Type_MEP_histo {
    sql: CASE
            WHEN ${typ_histo} IN ("I","Cyi") THEN "MEP"
          END ;;
    label: "Type MEP (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Type_City_histo {
    sql: CASE
            WHEN ${typ_histo} IN ("Cyi", "Cyf") THEN "City"
          END ;;
    label: "Type City (histo)"
    view_label: "Magasins (à date de vente)"
  }


  dimension: Groupe_Laser {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE LASER ET COPIEUR COMPATIBLE") THEN "Laser"
            WHEN ${n2_famille} IN ("CARTOUCHE JET D’ENCRE MARQUE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "JET D'ENCRE"
          END ;;
    view_label: "N2"
  }

  dimension: Groupe_Marq {
    sql: CASE
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR", "CARTOUCHE JET D’ENCRE MARQUE") THEN "Marques"
            WHEN ${n2_famille} IN ("CARTOUCHE LASER ET COPIEUR COMPATIBLE", "CARTOUCHE JET D’ENCRE COMPATIBLE") THEN "Compatible"
          END ;;
    view_label: "N2"
  }




############## calcul des KPIs à la période sélectionnée au niveau du filtre  ############

  measure: sum_CA_select_mois {
    type: sum
    value_format_name: eur
    label: "CA HT"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
    view_label: "Ventes"
    group_label: "Année N"
    link: {
      label: "City Metrics Explore"
      url: "https://bureauvallee.cloud.looker.com/embed/explore/bureauvallee_prod/pdt_famille?qid=3QkXg9rpz67sQ7zZPDW0Mw&origin_space=23&toggle=fil%2Cvis&vis_type=table"
    }
  }

  measure: sum_stock_mois {
    type: sum
    value_format_name: eur
    label: "Stock"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${stock}
          END ;;
    view_label: "Stocks"
    group_label: "Année N"
  }

  measure: sum_marge_select_mois {
    label: "Marge"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: taux_de_marge_select_mois {
    label: "% marge"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: sum_qte_select_mois {
    label: "Qte"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
    view_label: "Ventes"
    group_label: "Année N"
  }


  measure: sum_nb_jour_select_mois {
    label: "Nb jr"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
    view_label: "Ventes"
    group_label: "Année N"
  }


  measure: sum_surf_select_mois {
    type: average
    sql: ${surface};;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: ecarts_jour_select_mois {
    label: "écart jr"
    type: number
    sql:  ${sum_nb_jour_select_mois}-${sum_nb_jour_select_mois_N1} ;;
    view_label: "Ventes"
    group_label: "Année N"
  }


  measure: sum_tarif_select_mois {
    label: "Tarif produit HT"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_produit_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: sum_total_qte_com_select_mois {
    label: "Qte commandée"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${quantite_commandee}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: sum_total_ht_select_mois {
    label: "Total_HT"
    type: number
    sql: ${sum_tarif_select_mois} * ${sum_total_qte_com_select_mois} ;;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: marge_drive_select_mois {
    label: "marge drive"
    value_format_name: decimal_0
    type: number
    sql: ${sum_total_ht_select_mois}-${sum_val_achat_gbl_select_mois};;
    view_label: "Web"
    group_label: "Année N"
  }

  measure: DN_N {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_magasin}
          END ;;
    view_label: "Article"
    group_label: "Année N"
  }

  measure: sum_val_achat_gbl_select_mois {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }

  measure: prix_vente_select_mois {
    label: "Prix de Vente Moyen"
    value_format_name: eur
    type: number
    sql: ${sum_CA_select_mois} / NULLIF(${sum_qte_select_mois}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: prix_achat_moyen_select_mois {
    label: "Prix d'Achat Moyen"
    type: number
    value_format_name: eur
    sql:  (${sum_CA_select_mois} - ${sum_marge_select_mois}) / NULLIF(${sum_qte_select_mois}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N"
  }


  measure: sum_magasin_mois {
    type: count_distinct
    value_format_name: decimal_0
    label: "Nombre de magasin"
    sql:
        CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP) {% endcondition %} and ${qtite} != 0 and ${ca_ht} != 0
            THEN ${cd_magasin}
          END ;;
    view_label: "Ventes"
    group_label: "Année N"
  }


  ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



  measure: sum_CA_select_mois_N1 {
    label: "CA HT n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: sum_marge_select_mois_N1 {
    label: "Marge n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: taux_de_marge_select_mois_N1 {
    label: "% marge n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_CA_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: sum_qte_select_mois_N1 {
    label: "Qte n-1"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: sum_val_achat_gbl_select_mois_N1 {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }


  measure: sum_nb_jour_select_mois_N1 {
    label: "Nb jr n-1"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }


  measure: sum_tarif_select_mois_N1 {
    label: "Tarif Produit HT n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_produit_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: sum_total_qte_com_select_mois_N1 {
    label: "Quantité commandée n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${quantite_commandee}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: sum_total_ht_select_mois_N1 {
    label: "Total HT n-1"
    type: number
    sql: ${sum_tarif_select_mois_N1} * ${sum_total_qte_com_select_mois_N1} ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: marge_drive_select_mois_N1 {
    label: "Marge drive n-1"
    value_format_name: decimal_0
    type: number
    sql:  ${sum_total_ht_select_mois_N1}-${sum_val_achat_gbl_select_mois_N1};;
    view_label: "Web"
    group_label: "Année N-1"
  }

  measure: DN_N1 {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${cd_magasin}
          END ;;
    view_label: "Article"
    group_label: "Année N-1"
  }

  measure: prix_vente_select_mois_N1 {
    label: "Prix de Vente Moyen n-1"
    value_format_name: eur
    type: number
    sql: ${sum_CA_select_mois_N1} / NULLIF(${sum_qte_select_mois_N1}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: prix_achat_moyen_select_mois_N1 {
    label: "Prix d'Achat Moyen n-1"
    type: number
    value_format_name: eur
    sql:  (${sum_CA_select_mois_N1} - ${sum_marge_select_mois_N1}) / NULLIF(${sum_qte_select_mois_N1}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N-1"
  }


  ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



  measure: sum_CA_select_mois_N2 {
    label: "CA HT n-2"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  measure: sum_marge_select_mois_N2 {
    label: "Marge n-2"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  measure: taux_de_marge_select_mois_N2 {
    label: "% marge n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N2}/NULLIF(${sum_CA_select_mois_N2},0);;
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  measure: sum_qte_select_mois_N2 {
    label: "Qte n-2"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${qtite}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }


  measure: sum_nb_jour_select_mois_N2 {
    label: "Nb jr n-2"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }


  measure: DN_N2 {
    type: count_distinct
    value_format_name: decimal_0
    label: "DN n-2"
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${article}
          END ;;
    view_label: "Article"
    group_label: "Année N-2"
  }

  measure: prix_vente_select_mois_N2 {
    label: "Prix de Vente Moyen n-2"
    value_format_name: eur
    type: number
    sql: ${sum_CA_select_mois_N2} / NULLIF(${sum_qte_select_mois_N2}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }

  measure: prix_achat_moyen_select_mois_N2 {
    label: "Prix d'Achat Moyen n-2"
    type: number
    value_format_name: eur
    sql:  (${sum_CA_select_mois_N2} - ${sum_marge_select_mois_N2}) / NULLIF(${sum_qte_select_mois_N2}, 0) ;;
    view_label: "Ventes"
    group_label: "Année N-2"
  }



########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_mois {
    label: "prog CA"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: prog_Qte_select_mois {
    label: "prog Qte"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_qte_select_mois}-${sum_qte_select_mois_N1})/NULLIF(${sum_qte_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N"
  }

  measure: prog_marge_select_mois {
    label: "prog marge"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N"
  }

########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_mois_N {
    label: "prog CA n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: prog_Qte_select_mois_N {
    label: "prog Qte n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_qte_select_mois}-${sum_qte_select_mois_N1})/NULLIF(${sum_qte_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }

  measure: prog_marge_select_mois_N {
    label: "prog marge n-1"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
    view_label: "Ventes"
    group_label: "Année N-1"
  }




############## calcul des KPIs Semaine N-1  ############

  measure: sum_CA_select_semaine_N1 {
    type: sum
    value_format_name: eur
    label: "CA HT Semaine N-1"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${TABLE}.ca_ht_sn1
          END ;;
    view_label: "Ventes"
    group_label: "Semaine Année N-1"
  }

  measure: sum_marge_select_semaine_N1 {
    label: "Marge Semaine N-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${TABLE}.marge_brute_sn1
          END ;;
    view_label: "Ventes"
    group_label: "Semaine Année N-1"
  }

  measure: taux_de_marge_select_semaine_N1 {
    label: "% marge Semaine N-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_semaine_N1}/NULLIF(${sum_CA_select_semaine_N1},0);;
    view_label: "Ventes"
    group_label: "Semaine Année N-1"
  }

  measure: sum_qte_select_semaine_N1 {
    label: "Qte Semaine N-1"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${TABLE}.qtite_sn1
          END ;;
    view_label: "Ventes"
    group_label: "Semaine Année N-1"
  }

}
