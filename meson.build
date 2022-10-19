project(
    'csp-test',
    version: '0.0.0',
    license: 'GPL-3.0',
)

dc = find_program('dart')

dart_src = files(
    'src/main.dart'
)

custom_target(
    'dart_scripts',
    input : dart_src,
    output : 'script.js',
    command : [dc, 'compile', 'js', '-O3', '-o', '@OUTPUT@', '@INPUT@'],
    install : true,
    install_dir : join_paths(meson.source_root(), 'js'),
)

