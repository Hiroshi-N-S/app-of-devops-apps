c = get_config()

#------------------------------------------------------------------------------
# jupyter-server-proxy configuration
#------------------------------------------------------------------------------
c.ServerProxy.servers = {
  'code-server': {
    'command': [
      '/home/jovyan/node_modules/.bin/code-server',
        '--auth=none',
        '--disable-telemetry',
        '--disable-update-check',
        '--cert-host=mint.local',
        # '--cert=/etc/code-server/certs/ca.crt',
        # '--cert-key=/etc/code-server/certs/ca.key',
        # '--bind-addr=localhost:{port}',
        '--socket={unix_socket}',
        '--user-data-dir=/home/jovyan/work/.config/code-oss/',
        '--extensions-dir=/home/jovyan/work/.vscode-oss/extensions/',
    ],
    'timeout': 20,
    'launcher_entry': {
      'launcher_entry': True,
      'icon_path': '/etc/code-server/visual-studio-code-icons/vscode.svg',
      'title': 'Visual Studio Code',
    },
    'unix_socket': '/tmp/code-server',
  },
  'node-red': {
    'command': [
      '/home/jovyan/node_modules/.bin/node-red',
        '--port'    , '{port}',
        '--userDir' , '/home/jovyan/work/.node-red',
        '--define'  , 'contextStorage.default.module="localfilesystem"',
    ],
    'timeout': 20,
    'launcher_entry': {
      'launcher_entry': True,
      'icon_path': '/home/jovyan/node_modules/@node-red/editor-client/public/red/images/node-red-256.svg',
      'title': 'Node-RED',
    },
    'port': 1880,
  }
}
