#!/bin/bash

###
# ========================LICENSE_START=================================
# CPASS DataBase
# %%
# Copyright (C) 2019 - 2025 CSI Piemonte
# %%
# SPDX-FileCopyrightText: Copyright 2019 - 2025 | CSI Piemonte
# SPDX-License-Identifier: EUPL-1.2
# =========================LICENSE_END==================================
###
POSTGRESQL_PATH="D:/PostgreSQL/9.6/bin"

# viste
inputView="./view_names.txt"
while IFS= read -r line
do
  echo "$line"
  nameView=$(echo $line | xargs) 
  $POSTGRESQL_PATH/pg_dump --dbname=postgresql://cpass:cpass@10.136.6.151:5432/cpass --schema-only -t $nameView > ../viste/$nameView.sql
done < "$inputView"


# tabelle
inputTable="./table_names.txt"
while IFS= read -r line
do
  echo "$line"
  nameTable=$(echo $line | xargs) 
  $POSTGRESQL_PATH/pg_dump --dbname=postgresql://cpass:cpass@10.136.6.151:5432/cpass --schema-only -t $nameTable > ../tabelle/$nameTable.sql
done < "$inputTable"

