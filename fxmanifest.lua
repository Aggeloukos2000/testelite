fx_version "cerulean"
description "Basic React (TypeScript) & Lua Game Scripts Boilerplate"
author "Project Error"
version '1.0.0'
repository 'https://github.com/project-error/fivem-react-boilerplate-lua'
lua54 'yes'
game "gta5"

loadscreen 'loading.html'

files {
  "loading.html",
  'web/build/index.html',
  'web/build/**/*',
  "stream/META/*",
  'files/errors.fnx',
  'stream/propradio/*.ydr',
  'stream/propradio/_manifestPropRadio.ymf',
  'stream/propradio/prop_serto_radio.ytyp'
}

ui_page 'web/build/index.html'

shared_script {
  	'@ox_lib/init.lua',
  	'translations.lua',
  	'maps.lua',
  	'items.lua',
	'armi.lua'
}

client_script {
  "client/**/*",
  
  'UTIIL/client.lua',
  'UTIIL/BoxZone.lua',
  'UTIIL/EntityZone.lua',
  'UTIIL/CircleZone.lua',
  'UTIIL/ComboZone.lua',
  'UTIIL/creation/client/*.lua',

  'MENU/Utils/screenToWorld.lua',
	'MENU/Utils/TextAlignment.lua',
	'MENU/Utils/TextFont.lua',
	'MENU/Utils/Log.lua',
	'MENU/Utils/Color.lua',

	'MENU/DefaultValues.lua',

	'MENU/Graphics2D/Object2D.lua',
	'MENU/Graphics2D/Rect.lua',
	'MENU/Graphics2D/Text.lua',
	'MENU/Graphics2D/Sprite.lua',
	'MENU/Graphics2D/SpriteUV.lua',
	'MENU/Graphics2D/Container.lua',
	'MENU/Graphics2D/Border.lua',

	'MENU/Items/BaseItem.lua',
	'MENU/Items/SeparatorItem.lua',
	'MENU/Items/ScrollItem.lua',
	'MENU/Items/PageItem.lua',
	'MENU/Items/TextItem.lua',
	'MENU/Items/Item.lua',
	'MENU/Items/SpriteItem.lua',
	'MENU/Items/SubmenuItem.lua',
	'MENU/Items/CheckboxItem.lua',

	'MENU/Menu/Menu.lua',
	'MENU/Menu/ScrollMenu.lua',
	'MENU/Menu/PageMenu.lua',
	'MENU/Menu/MenuPool.lua',

	'MENU/Menu/ExportMenu.lua',

	'DP/Client/Functions.lua', 
	'DP/Locale/en.lua', 			
	'DP/Client/Config.lua',		
	'DP/Client/Variations.lua',		
	'DP/Client/Clothing.lua',
	'DP/Client/GUI.lua',
}
server_script {
	"server/**/*",
	'UTIIL/creation/server/*.lua',
    'UTIIL/server.lua',
}

data_file 'DLC_ITYP_REQUEST' 'propradio/prop_serto_radio.ytyp'