from diagrams import Diagram, Cluster
from diagrams.onprem.compute import Server
from diagrams.onprem.database import MySQL
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.network import Internet

with Diagram("Vagrant VM Setup", show=False):
    with Cluster("Local Network Bridge - eno1"):
        with Cluster("VM1"):
            vm1 = Server("vm1")
            mysql = MySQL("MySQL")
            prometheus_exporter = Prometheus("Prometheus MySQL Exporter")
            node_exporter = Prometheus("Node Exporter")

            vm1 - mysql
            vm1 - prometheus_exporter
            vm1 - node_exporter

        with Cluster("VM2"):
            vm2 = Server("vm2")
            prometheus = Prometheus("Prometheus")
            grafana = Grafana("Grafana")

            vm2 - prometheus
            vm2 - grafana

        internet = Internet("Internet")
        internet - vm1
        internet - vm2
