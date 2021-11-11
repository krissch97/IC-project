import graphviz
import pydot


f = graphviz.Digraph('finite_state_machine', filename='fsm.gv', format='png')
f.attr(rankdir='LR', size='8,5')

f.engine = 'circo'

f.attr('node', shape='circle')
f.node('IDLE')
f.node('ERASE')
f.node('EXPOSE')
f.node('CONVERT')
f.node('READ0')
f.node('READ1')
f.node('READ2')
f.node('READ2')
#f.node('cntr reset')

#f.edge('IDLE', 'ERASE', label='SS(B)')
#
#f.edge('IDLE', 'EXPOSE', label='S($end)')
#
#f.edge('IDLE', 'CONVERT', label='SS(a)')
#
#f.edge('IDLE', 'READ0', label='S(b)')
#f.edge('READ0', 'READ1', label='S(a)')
#f.edge('READ1', 'READ2', label='S(b)')
#f.edge('READ2', 'READ3', label='S(a)')
#f.edge('READ3', 'IDLE', label='S(b)')

f.edge('IDLE', 'ERASE')
f.edge('ERASE', 'ERASE', label='cntr ≠ c_erase')
f.edge('ERASE', 'EXPOSE', label='cntr = c_erase')
f.edge('EXPOSE', 'EXPOSE', label='cntr ≠ c_expose')
f.edge('EXPOSE', 'CONVERT', label='cntr = c_expose')
f.edge('CONVERT', 'CONVERT', label='cntr ≠ c_convert')
f.edge('CONVERT', 'READ0', label='cntr = c_convert')
f.edge('READ0', 'READ0', label='cntr ≠ c_read')
f.edge('READ0', 'READ1', label='cntr = c_read')
f.edge('READ1', 'READ1', label='cntr ≠ 2·c_read')
f.edge('READ1', 'READ2', label='cntr = 2·c_read')
f.edge('READ2', 'READ2', label='cntr ≠ 3·c_read')
f.edge('READ2', 'READ3', label='cntr = 3·c_read')
f.edge('READ3', 'READ3', label='cntr ≠ 4·c_read')
f.edge('READ3', 'IDLE', label='cntr = 4·c_read')

#f.unflatten(stagger=10)
#f.edge('ERASE', 'IDLE', label='reset=1')
#f.edge('EXPOSE', 'IDLE', label='reset=1')
#f.edge('CONVERT', 'IDLE', label='reset=1')
#f.edge('READ0', 'IDLE', label='reset=1')
#f.edge('READ1', 'IDLE', label='reset=1')
#f.edge('READ2', 'IDLE', label='reset=1')
#f.edge('READ3', 'IDLE', label='reset=1')

f.view()