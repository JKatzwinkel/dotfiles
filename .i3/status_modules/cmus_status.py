# -*- coding: utf-8 -*-
"""
Display cmus current song.


Configuration parameters:
    cache_timeout: How often we refresh this module in seconds (default 0.5)
    format: display format for window_title (default '{title}')
    max_width: If width of title is greater, shrink it and add '...'
        (default 120)

"""

STATUS_ICON = {
        'playing': '',
        'paused': '',
        'stopped': '⏹',
        None: '-',
}

PROGRESS_ICON = [
        '🌕',
        '🌔',
        '🌓',
        '🌒',
        '🌑',
        '🌘',
        '🌗',
        '🌖',
        '🌕',
]


def status_dict(output):
    d = {}
    for line in output.split('\n'):
        key, *values = line.split(' ')
        if key in ['tag', 'set']:
            key, *values = values
        d[key] = ' '.join(values)
    return d


class Py3status:
    """
    """
    # available configuration parameters
    cache_timeout = 0.5
    format = u'{status} {title} {progress}'
    max_width = 32

    def __init__(self):
        pass

    def window_title(self):
        try:
            tree = status_dict(self.py3.command_output('cmus-remote -Q'))
        except Exception:
            tree = {}

        progress = '-'
        title = '-'
        status = STATUS_ICON.get(tree.get('status'))

        if 'artist' in tree and 'title' in tree:
            title = '{} - {}'.format(
                    tree.get('artist', ''),
                    tree.get('title', '')
            )

        if 'position' in tree and 'duration' in tree:
            progress = 9 * int(tree.get('position')) // int(tree.get('duration'))
            progress = PROGRESS_ICON[progress]

        return {
            'cached_until': self.py3.time_in(self.cache_timeout),
            'full_text': self.py3.safe_format(
                self.format,
                {
                    'progress': progress,
                    'title': title,
                    'status': status,
                }
            ),
            'color': self.py3.COLOR_GOOD
        }


if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test
    module_test(Py3status)
