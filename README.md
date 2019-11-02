# Monster Shop
BE Mod 2 Week 4/5 Group Project

## Installation Instructions

This application is currently deployed to Heroku. Follow [this link](https://monster-shop-be-1908.herokuapp.com) to see it in action.

If you would like to experience the web application on your local device, navigate to a directory within which you want to clone the repository and run these commands in the terminal.

```
git clone git@github.com:grwthomps/monster_shop_1908.git monster_shop
cd monster_shop
bundle install
bundle update
rake db:{drop,create,migrate,seed}
rails server
```

Finally, open up a web browser and navigate to http://localhost:3000.


## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can shop for items. Visitors and users can browse items and add them to a shopping cart. Once registered with an account and logged in, users can checkout with their shopping cart and create an order. Users that work for merchants will see orders with their items and can fulfill them. Once an entire order has been fulfilled, an administrator can then ship the order. Restrictions are in place so that users can only access pages and information they are meant to access. Edge cases and sad paths have been tested to ensure optimal functionality.


## User Roles


1. Visitor
1. Regular User
1. Merchant Employee
3. Merchant Administrator
3. Administrator

## Visitor

A visitor is any user browsing our the site who is not logged in. As a  visitor, they have the following access:

### Shopping:

- Browsing all items
- Adding items to cart
- Required login or registration for orders

### Views:

- Persisting navigation bar
- All items
- Item statistics
- All merchants
- Cart

![](../media/visitor.gif?raw=true)

## Regular User

Regular users are registered and logged in to the site with the same abilities as a vistor as well as:

### Shopping:

- Browsing all items
- Adding items to a cart
- Placing orders

### Views:

- Profile
- Orders

### Profile Creation:

- Registering with personal information
- Logging in with unique email and password confirmation
- Editing profile information

### Order management:

- Viewing their order details
- Cancelling their unshipped orders

![](../media/default_user.gif?raw=true)

## Merchant employee

A merchant employee works for a merchant and can fulfill orders for that merchant. They have the same capabilities as regular users but can also:

### Shopping:

- Browsing all items
- Adding items to cart
- Placing Orders


### Views:

- Dashboard
- Merchant Items

### Order management:

- Viewing their own items in an order
- Fulfilling items in an order

### Merchant management:

- Creating a new item
- Editing an existing item
- Marking items active or inactive
- Deleting an item

![](../media/merchant_employee.gif?raw=true)

## Merchant Admin

Merchant administrators also work for a merchant but have additional capabilities to merchant employees. Merchant administrators have the following permissions:


### Profile Management:

- Editing account info
- Changing password

### Merchant management:

- Creating a new item
- Editing an existing item
- Marking items active or inactive
- Deleting an item
- Editing Merchant info

### Order Management:

- Viewing their own items in an order
- Fulfilling items in an order

![](../media/merchant_admin.gif?raw=true)

## Admin

Administrators have extensive access and permissions. Their permissions include:

### Profile Management:

- Editing account info
- Changing password

### Views:

- All orders
- All users
- All merchants

### Order Management:

- Shipping orders

### Site Management:

- Enabling and disabling users
- Enabling and disabling merchants

However, there are some things that Administrators **cannot** do. These include:

### Shopping:

- Adding items to a cart
- Placing orders

### Merchant management:

- Creating a new item
- Editing an existing item
- Marking items active or inactive
- Deleting an item

In addition, Administrators **cannot** edit a user's profile information or change their password.

![](../media/admin.gif?raw=true)

---

## Order Status

1. 'pending' means a user has placed items in a cart and "checked out" to create an order, merchants may or may not have fulfilled any items yet
2. 'packaged' means all merchants have fulfilled their items for the order, and has been packaged and ready to ship
3. 'shipped' means an admin has 'shipped' a package and can no longer be cancelled by a user
4. 'cancelled' - only 'pending' and 'packaged' orders can be cancelled


---

## Items

This is the main "catalog" page of the entire site where users will start their e-commerce experience. Visitors to the site, and regular users, will be able to view an index page of all items available for purchase and some basic statistics. Each item will also have a "show" page where more information is shown.

---

## User Profile Page

When a user who is not a merchant nor an admin logs into the system, they are taken to a profile page under a route of "/profile".

### Admins can act on behalf of users
Admin users can access a namespaced route of "/admin/users" to see an index page  of all non-merchant/non-admin users, and from there see each user. This will allow the admin to perform every action on a user's account that the user themselves can perform.

---

## Shopping Cart and Checkout

This is what this app is all about: how a user can put things in a shopping cart and check out, creating an order in the process. Admin users cannot order items.

A visitor can add items to their cart, but must login or register in order to check out. Upon checkout, an order is created in the system with a status of 'pending'.

---

## User Order Show Page

The order show page indicates order information in table format, including the order ID, status, and information about the price and quantity of each item in the order. Different user types have different controls on this page.

### User Control
- Users can cancel an order if an admin has not "shipped" that order
- When an order is cancelled, any fulfilled items have their inventory returned to their respective merchants

### Merchant Control
- Merchants only see items in the order that are sold by that merchant
- Items from other merchants are hidden

### Admin Control
- Admins can cancel an order on behalf of a user
- Admins can fulfill items on order on behalf of a merchant

---

## Merchant Dashboard

This is the landing page when a merchant logs in. Here, they will see their contact information (but cannot change it), some statistics, and a list of pending orders that require the merchant's attention.

### Admins can act on behalf of merchants

Admin users will see more information on the "/merchants" route that all users see. For example, on this page, an admin user can navigate to each merchant's dashboard under a route like "/admin/merchants/7". This will allow the admin to perform every action that the merchant themselves can perform.

---

## Merchant Index Page

All users can see a merchant index page at "/merchants" which will list some basic information about each merchant. When admins visit this page, however, they have the ability to toggle merchant status between enabled and disabled. Enabling a merchant causes all of the merchant's items to have a status of active. Disabling causes all of the merchant's items to have a status of inactive. Inactive items are not shown on the main items index and are therefore not available for purchase.

---

## Merchant Items

Merchants can create new items and edit existing items from their items index page. Merchants can also enable inactive items and disable items so they are no longer for sale but stay in the database so orders are still handled properly.

---

## Merchant Order Fulfillment

Merchants must "fulfill" each ordered item for users. They can visit an order show page which will allow them to mark each item as fulfilled. Once every merchant marks their items for an order as "fulfilled" then the whole order switches its status to "packaged". Merchants cannot fulfill items in an order if they do not have enough inventory in stock. If a user cancels an order after a merchant has fulfilled an item, the quantity of that item is returned to the merchant.

### Admin functionality
Admins can fulfill items in an order on behalf of a merchant.

---

## User Management by Admins

Admins can view a list of all regular users and view their profile and order data. They can also navigate to an a user's order show page and cancel existing orders that are not yet shipped.
