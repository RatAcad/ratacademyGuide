# DataJoint access

Ratacademy data is stored in a **MySQL database on AWS** (Amazon RDS), organized
with [DataJoint](https://datajoint.com/). To browse or analyze it you need:

1. a MySQL user account on the database server
2. access to the [RatAcad GitHub organization](https://github.com/RatAcad)
3. the [`dj_ratacad`](https://github.com/RatAcad/dj_ratacad) package (see
   [Data pipeline](pipeline.md))

!!! info "Database host"
    The server address isn't published on this public site. Ask the RatAcad
    maintainers for it. Below it is written as `<DB_HOST>`.

## 1. Request a database account

At BU, accounts are made by IS&T. Email your IT helpdesk and include:

- **username**: your institutional username
- **host**: `<DB_HOST>`
- **where you will connect from**: e.g. home laptop over VPN, campus Wi-Fi,
  campus Ethernet. The server only accepts connections from approved networks.

IT will send a temporary password by secure mail.

## 2. Install a MySQL client and change your password

=== "macOS"

    ```bash
    # install Homebrew first: https://brew.sh
    brew install mysql-client
    ```

=== "Ubuntu"

    ```bash
    sudo apt install mysql-client
    ```

Log in with the temporary password:

```bash
mysql -h <DB_HOST> -u <your_username> -p
```

Then set your own password:

```sql
ALTER USER '<your_username>'@'<allowed_host_pattern>' IDENTIFIED BY '<new_password>';
```

`<allowed_host_pattern>` is the network pattern IT set up for your account
(e.g. `'168.122.%'`). Run `SELECT CURRENT_USER();` to see it.

## 3. GitHub access

Ask the RatAcad maintainers to add you to the
[RatAcad GitHub organization](https://github.com/RatAcad).

## 4. Connect with DataJoint and fetch data

Follow the [Data pipeline → Querying data](pipeline.md#querying-data) section and the
[`dj_ratacad` README](https://github.com/RatAcad/dj_ratacad).
