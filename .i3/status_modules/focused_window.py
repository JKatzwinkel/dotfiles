import i3

def focused():
  focs=i3.filter(focused=True)
  for n in focs:
    props = n.get('window_properties',{})
    t = props.get('title','')
    c = props.get('class', '')
    focwin = '{} {}'.format(t, ['{}','({})'][int(len(c)>0)].format(c))
  return focwin

class Py3status:
  def focused_window(self, i3s_output_list, i3s_config):
    return {'full_text': focused()}

if __name__ == "__main__":
  from time import sleep
  x = Py3status()
  while True:
    print(x.focused_window([], {}))
    sleep(1)
