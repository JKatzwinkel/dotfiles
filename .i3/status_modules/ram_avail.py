# -*- coding: utf-8 -*-
"""
Display the percentage of available RAM.

"""

import re

num = re.compile(r'[0-9]+')

UNIT = [
        'k',
        'M',
        'G',
]

def ram_stats():
    d = {}
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            k, value = line.strip().split(':')
            d[k] = int(num.findall(value)[0])
    return d


def fmt(n):
    mag = 0
    while n > 1024:
        n //= 1024
        mag += 1
    return '{}{}'.format(n, UNIT[mag])


class Py3status:
    """
    """
    # available configuration parameters
    cache_timeout = 0.5
    format = '{ram_avail} {ram_percent}%'
    max_width = 120

    def __init__(self):
        self.title = ''

    def window_title(self):

        stats = ram_stats()
        ram_avail = stats.get('MemAvailable')
        ram_total = stats.get('MemTotal')
        ram_percent = 100 * ram_avail // ram_total

        return {
            'full_text': self.py3.safe_format(
                self.format,
                {
                    'ram_percent': ram_percent,
                    'ram_avail': fmt(ram_avail),
                    'ram_total': fmt(ram_total),
                }
            ),
            'color': self.py3.COLOR_GOOD if ram_percent > 25 else self.py3.COLOR_BAD
        }


if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test
    module_test(Py3status)
