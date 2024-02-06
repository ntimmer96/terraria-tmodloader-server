FROM ubuntu:jammy

ARG VERSION=latest

ENV TERRARIA_VERSION=$VERSION

ENV LATEST_VERSION=""

ENV PATH="/scripts:${PATH}"

ENV BASE_PATH=/root/.local/share/Terraria/ModLoader

ENV MODS_DIR=${BASE_PATH}/Mods

ENV WORLDS_DIR=${BASE_PATH}/Worlds

ENV PLAYERS_DIR=${BASE_PATH}/Players

ENV VERSION_FILE=${BASE_PATH}/versions.txt

ENV TMODLOADER_VERSION=""

RUN mkdir -p ${MODS_DIR} ${WORLDS_DIR} ${PLAYERS_DIR} /scripts && \
    touch ${VERSION_FILE}

WORKDIR ${BASE_PATH}

COPY ./.scripts /scripts

RUN chmod +x /scripts/*

RUN mv /scripts/init-tModLoaderServer.sh ${BASE_PATH}

RUN apt update -y && apt install -y unzip curl findutils

RUN if [ "${TERRARIA_VERSION}" = "latest" ]; then \
        echo "using latest version." \
    &&  export LATEST_VERSION=$(get-terraria-version.sh) \
    &&  export TERRARIA_VERSION=${LATEST_VERSION}; fi \
    && echo "TERRARIA_VERSION=${TERRARIA_VERSION}" \
    && echo "${TERRARIA_VERSION}" > ${BASE_PATH}/terraria-version.txt \
    && curl https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip --output terraria-server.zip \  
    && unzip terraria-server.zip -d ${BASE_PATH} && mv ${BASE_PATH}/*/* ${BASE_PATH} \
    && rm -rf terraria-server.zip ${BASE_PATH}/Mac ${BASE_PATH}/Windows ${BASE_PATH}/${TERRARIA_VERSION} \
    && mv ${BASE_PATH}/Linux/* ${BASE_PATH}/ \
    && rm -rf ${BASE_PATH}/Linux \
    && cd ${BASE_PATH} \
    && chmod +x TerrariaServer.bin.x86_64*

### TModLoader Installation and Setup
# Logic

# Get Terraria Server Version
RUN export TERRARIA_VERSION=$(get-terraria-version.sh | sed 's/[0-9]/&./g' | sed 's#.$##') \
    echo "terrariaServer=${TERRARIA_VERSION}" | tee -a ${VERSION_FILE}

# # tModLoader
# RUN output=$(/scripts/get-tmodloader-1_3.sh) \
#     && echo ${output} | tee -a ${VERSION_FILE} \
#     && unzip -o tmodloader-server.zip -d ${BASE_PATH}/ \
#     && rm tmodloader-server.zip \
#     && chmod +x ${BASE_PATH}/tModLoaderServer*

## Fixed tModLoader Version: v0.11.8.9 (last 1.3 version)
RUN curl -L --silent https://github.com/tModLoader/tModLoader/releases/tag/v2023.12.3.1 \
    --output tmodloader-server.zip \
    && echo "tModLoader: v0.11.8.9" | tee -a ${VERSION_FILE} \
    && unzip -o tmodloader-server.zip -d ${BASE_PATH}/ \
    && rm tmodloader-server.zip \
    && chmod +x ${BASE_PATH}/tModLoaderServer*

# AlchemistNPC
RUN mkdir -pv ${MODS_DIR} && ls -alh ${MODS_DIR}

RUN output=$(get-mod.sh https://github.com/VVV101/AlchemistNPC ${MODS_DIR} AlchemistNPC) \
    && echo ${output} | tee -a ${VERSION_FILE}

# AlchemistNPClite
RUN output=$(get-mod.sh https://github.com/VVV101/AlchemistNPCLite ${MODS_DIR} AlchemistNPClite) \
    && echo ${output} | tee -a ${VERSION_FILE}

# BossChecklist Mod
RUN output=$(get-mod.sh https://github.com/JavidPack/BossChecklist ${MODS_DIR} BossChecklist) \
    && echo ${output} | tee -a ${VERSION_FILE}

# CalamityMod 
RUN output=$(get-mod.sh https://github.com/MountainDrew8/CalamityMod ${MODS_DIR} CalamityMod) \
    && echo ${output} | tee -a ${VERSION_FILE}

# CalamityMusicMod
RUN output=$(get-mod.sh https://github.com/CalamityTeam/CalamityModMusicPublic ${MODS_DIR} CalamityMusicMod) \
    && echo ${output} | tee -a ${VERSION_FILE}

# ExtensibleInventory
RUN output=$(get-mod.sh https://github.com/hamstar0/tml-extensibleinventory-mod ${MODS_DIR} ExtensibleInventory) \
    && echo ${output} | tee -a ${VERSION_FILE}

# Fargowiltas
RUN output=$(get-mod.sh https://github.com/Fargowilta/Fargowiltas ${MODS_DIR} Fargowiltas) \
    && echo ${output} | tee -a ${VERSION_FILE}

# FargowiltasSouls
RUN output=$(get-mod.sh https://github.com/Fargowilta/FargowiltasSouls ${MODS_DIR} FargowiltasSouls) \
    && echo ${output} | tee -a ${VERSION_FILE}

# FargowiltasSoulsDLC
RUN output=$(get-mod.sh https://github.com/Fargowilta/FargowiltasSoulsDLC ${MODS_DIR} FargowiltasSoulsDLC) \
    && echo ${output} | tee -a ${VERSION_FILE}

# MagicStorageExtra
RUN output=$(get-mod.sh https://github.com/ExterminatorX99/MagicStorageExtra ${MODS_DIR} MagicStorageExtra) \
    && echo ${output} | tee -a ${VERSION_FILE}

# RecipeBrowser
RUN output=$(get-mod.sh https://github.com/JavidPack/RecipeBrowser ${MODS_DIR} RecipeBrowser) \
    && echo ${output} | tee -a ${VERSION_FILE}
    
# SpiritMod
RUN output=$(/scripts/get-mod.sh https://github.com/PhoenixBladez/SpiritMod ${MODS_DIR} SpiritMod) \
    && echo ${output} | tee -a ${VERSION_FILE}   

# TerrariaOverhaul
RUN output=$(get-mod.sh https://github.com/Mirsario/TerrariaOverhaul ${MODS_DIR} TerrariaOverhaul) \
    && echo ${output} | tee -a ${VERSION_FILE}

# ThoriumMod
RUN output=$(get-mod.sh https://github.com/SamsonAllen13/ThoriumMod ${MODS_DIR} ThoriumMod) \
    && echo ${output} | tee -a ${VERSION_FILE}

# Tremor
RUN output=$(get-mod.sh https://github.com/IAmBatby/Tremor ${MODS_DIR} Tremor) \
    && echo ${output} | tee -a ${VERSION_FILE}

# WingSlot
RUN output=$(get-mod.sh https://github.com/abluescarab/tModLoader-WingSlot ${MODS_DIR} WingSlot) \
    && echo ${output} | tee -a ${VERSION_FILE}

# WMITF
RUN output=$(get-mod.sh https://github.com/gardenappl/WMITF ${MODS_DIR} WMITF) \
    && echo ${output} | tee -a ${VERSION_FILE}

RUN touch ${MODS_DIR}/enabled.json \
    && echo '[' >> enabled.json \
    && echo '   "BossChecklist",' >> enabled.json \
    && echo '   "MagicStorageExtra",' >> enabled.json \
    && echo '   "RecipeBrowser",' >> enabled.json \
    && echo '   "ThoriumMod"' >> enabled.json \
    && echo ']' >> enabled.json

### Image variables

ENV autocreate=2

ENV seed=

ENV worldname=TerrariaWorld

ENV difficulty=0

ENV maxplayers=16

ENV port=7777

ENV password=''

ENV motd="Welcome!"

ENV worldpath=${WORLDS_DIR}/

ENV banlist=banlist.txt

ENV secure=1

ENV language=en/US

ENV upnp=1

ENV npcstream=1

ENV priority=1

# Logic

WORKDIR ${BASE_PATH}

VOLUME ["/root/.local/share/Terraria/ModLoader/Worlds"]

ENTRYPOINT [ "./init-tModLoaderServer.sh" ]
