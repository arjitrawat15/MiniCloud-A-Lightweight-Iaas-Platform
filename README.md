# 🧠 MiniCloud – A Lightweight IaaS Platform

MiniCloud is a lightweight, educational Infrastructure-as-a-Service (IaaS) platform that demonstrates how cloud systems like AWS EC2 + S3 work — built from scratch using QEMU/KVM, FastAPI, and React.

It lets users:

Create, start, stop, and reboot virtual machines programmatically.

Store and retrieve files using a custom S3-like object store.

Manage everything through a simple web dashboard.

🚀 Features

🧩 VM Orchestrator — Manage QEMU-based virtual machines via REST API.

☁️ Object Storage — S3-like storage with PUT/GET/LIST endpoints (FastAPI).

🧱 Guest OS Image — Minimal Linux image built with BusyBox and initramfs.

💻 Web Dashboard — React interface to manage VMs and files.

🗄️ SQLite Metadata DB — Store VM states, buckets, and user data.
