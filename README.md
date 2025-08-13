# H/W 7.03. Домашнее задание к занятию "`Подъём инфраструктуры в Yandex Cloud`" - `Моторин Алексей`

### Файлы проекта
:book: [Подробнее на Google DOCs](https://docs.google.com/document/d/18CEnHFG5cI6Unp4Kg1IHxTEh2VrBvS5KErNtBIJPmdU/edit?usp=sharing)
```
.
├── .gitignore               # Игнорируемые файлы (кеш, ключи и т.д.)
├── .terraform.lock.hcl      # Фиксация версий провайдеров
├── ansible.cfg              # Конфигурация Ansible
├── cloud-init.yml           # Cloud-init конфигурация для ВМ
├── hosts.ini                # Инвентарь Ansible
├── main.tf                  # Основная конфигурация Terraform
├── network.tf               # Настройки сети (VPC, подсети)
├── providers.tf             # Настройки провайдеров Terraform
├── terraform.tfvars         # Переменные Terraform (значения)
├── terraform.tfstate        # Состояние инфраструктуры (не коммитить!)
├── terraform.tfstate.backup # Бэкап состояния (не коммитить!)
├── test.yml                 # Playbook/тесты Ansible
└── variables.tf             # Объявление переменных Terraform
```
