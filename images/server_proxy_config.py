c = get_config()

#------------------------------------------------------------------------------
# jupyter-server-proxy configuration
#------------------------------------------------------------------------------
c.ServerProxy.servers = {
  'code-server': {
    'command': [
      'code-server',
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
  }
}
