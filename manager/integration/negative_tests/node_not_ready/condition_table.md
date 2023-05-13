 ## node_power_off.robot
  test case | node 1 | node 2 | node 3 
 --|--|--|--
 1 | <br><li>replica</li><li>attached</li><li>power off</li><br> | replica | replica
 2 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>power off</li><br>  | replica
 3 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>power off</li><br> 
 4 | <br><li>replica</li><li>power off</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 5 | <br><li>replica</li><li>attached</li><li>power off</li><br> | <br><li>replica</li><br>  |
 6 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>power off</li><br>
 7 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>power off</li><br>  |
 8 | <br><li>replica</li><li>attached</li><li>power off time out</li><br> | replica | replica
 9 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>power off time out</li><br>  | replica
 10 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>power off time out</li><br> 
 11 | <br><li>replica</li><li>power off  time out</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 12 | <br><li>replica</li><li>attached</li><li>power off time out</li><br> | <br><li>replica</li><br>  |
 13 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>power off time out</li><br>
 14 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>power off time out</li><br>  |


  ## node_reboot.robot
  test case | node 1 | node 2 | node 3 
 --|--|--|--
 1 | <br><li>replica</li><li>attached</li><li>reboot</li><br> | replica | replica
 2 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>reboot</li><br>  | replica
 3 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>reboot</li><br> 
 4 | <br><li>replica</li><li>reboot</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 5 | <br><li>replica</li><li>attached</li><li>reboot</li><br> | <br><li>replica</li><br>  |
 6 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>reboot</li><br>
 7 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>reboot</li><br>  |

  ## restart_kubelet.robot
  test case | node 1 | node 2 | node 3 
 --|--|--|--
 RWO volume
 1 | <br><li>replica</li><li>attached</li><li>restart kubelet</li><br> | replica | replica
 2 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet</li><br>  | replica
 3 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>restart kubelet</li><br> 
 4 | <br><li>replica</li><li>restart kubelet</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 5 | <br><li>replica</li><li>attached</li><li>restart kubelet</li><br> | <br><li>replica</li><br>  |
 6 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>restart kubelet</li><br>
 7 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet</li><br>  |
 15 | <br><li>replica</li><li>attached</li><li>restart kubelet time out</li><br> | replica | replica
 16 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet time out</li><br>  | replica
 17 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>restart kubelet time out</li><br> 
 18 | <br><li>replica</li><li>restart kubelet  time out</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 19 | <br><li>replica</li><li>attached</li><li>restart kubelet time out</li><br> | <br><li>replica</li><br>  |
 20 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>restart kubelet time out</li><br>
 21 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet time out</li><br>  |
RWX volume
 8 | <br><li>replica</li><li>attached</li><li>restart kubelet</li><br> | replica | replica
 9 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet</li><br>  | replica
 10 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>restart kubelet</li><br> 
 11 | <br><li>replica</li><li>restart kubelet</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 12 | <br><li>replica</li><li>attached</li><li>restart kubelet</li><br> | <br><li>replica</li><br>  |
 13 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>restart kubelet</li><br>
 14 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet</li><br>  |
 22 | <br><li>replica</li><li>attached</li><li>restart kubelet time out</li><br> | replica | replica
 23 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet time out</li><br>  | replica
 24 | <br><li>replica</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><li>restart kubelet time out</li><br> 
 25 | <br><li>replica</li><li>restart kubelet  time out</li><br> | <br><li>replica</li><br>  | <br><li>attached</li><br>
 26 | <br><li>replica</li><li>attached</li><li>restart kubelet time out</li><br> | <br><li>replica</li><br>  |
 27 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><br>  |<br><li>restart kubelet time out</li><br>
 28 | <br><li>replica</li><li>attached</li><br> | <br><li>replica</li><li>restart kubelet time out</li><br>  |