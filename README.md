# H/W 7.03. Файлы проекта terraform, домашнего задания "`Подъём инфраструктуры в Yandex Cloud`" - `Моторин Алексей`

:book: [Подробнее на Google DOCs](https://docs.google.com/document/d/18CEnHFG5cI6Unp4Kg1IHxTEh2VrBvS5KErNtBIJPmdU/edit?usp=sharing)
```
├── templates/               # Директория с шаблонами
│   └── index.html.j2.html   # Шаблон стартовой страницы 
├── .gitignore               # Игнорируемые файлы (кеш, ключи и т.д.)
├── ansible.cfg              # Конфигурация Ansible
├── cloud-init.yml           # Cloud-init конфигурация для ВМ
├── config                   # SSH config
├── hosts.ini                # Инвентарь Ansible
├── main.tf                  # Основная конфигурация Terraform
├── network.tf               # Настройки сети (VPC, подсети)
├── providers.tf             # Настройки провайдеров Terraform
├── terraform.tfvars         # Переменные Terraform (значения)
├── test.yml                 # Playbook/тесты Ansible
├── variables.tf             # Объявление переменных Terraform
└── web.yaml                 # Плейбук для разворачивания WEB серверов 
```
