# laravel-docker
Use docker for laravel

## Steps to do:

### Step 1: 
- Clone this repo: ```git clone https://github.com/thechowdary/laravel-docker/```
- `git checkout develop`
- You can change the port number in docker-compose.yml, default set to 8003 in the nginx configuration in this file.
- Set the database details in the .env file

### Step 2: Files & Database
- `cd laravel`
- Download laravel to this location. If it's a new laravel application, use `git clone https://github.com/laravel/laravel .`
- You may need to set the same port number in .env file, that was there in step 1.
- Also don't forget to set .env file. you may need to copy from .env.example to .env, if its a new laravel application.
- If it's an old application, Put your exported db's sql file to `docker-compose/mysql` folder by replacing existing sql file.

### Step 3: 
- `docker-compose build`

### Step 4: 
- `docker-compose up -d`

### Step 5: 
- `docker-compose exec app ls -l`

### Step 6: 
- `docker-compose exec app rm -rf vendor composer.lock`

### Step 7: 
- `docker-compose exec app composer install`

### Step 8: 
- `docker-compose exec app php artisan key:generate`
- From the ./laravel/.env file change DB_HOST value to the db container name. In my case, it's `myproject-db`

### Step 9: 
- `docker-compose exec app php artisan migrate`

### Step 10: 
##### Clearing Laravel Cache 
- `docker-compose exec app php artisan config:clear` - Clears Configuration Cache
- `docker-compose exec app php artisan cache:clear` - Clears Application Cache
- `docker-compose exec app php artisan route:cache` - Clears Route Cache
- `docker-compose exec app php artisan view:cache` - Generates View Cache
- `docker-compose exec app php artisan view:clear` - Clears View Cache
- `docker-compose exec app php artisan view:optimize` - Optimizes View Cache
- `docker-compose exec app php artisan cache:flush` - Clears Application Cache 
- `docker-compose exec app php artisan cache:flush --all` - Clears All Cache

Step 11: Visit http://localhost:8003/ <8003: port_number that was set in the step 1 and step 2>

# LARAVEL CRUD Operation

### Step 1: Create a database table

`php artisan make:migration create_books_table --create=books`

This command will create a new migration file in the `database/migrations` directory. Open the migration file and define the table schema:

```
Schema::create('books', function (Blueprint $table) {
    $table->id();
    $table->string('title');
    $table->string('author');
    $table->text('description');
    $table->integer('price');
    $table->timestamps();
});
```

The above schema will create a table with columns id, title, author, description, price and timestamps.

### Step 2: Create a model

Next, we need to create a model to interact with the books table. We can use the following command to create a new model:

`php artisan make:model Book`

This command will create a new model file in the `app/Models` directory. Open the model file and define the table schema:

```
namespace App;

use Illuminate\Database\Eloquent\Model;

class Book extends Model
{
    protected $fillable = ['title', 'author', 'description', 'price'];
}
```

### Step 3: Create a controller

`php artisan make:controller BookController --resource --model=Book`

Open the BookController.php file and add the following code:

```
<?php
namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\View\View;

class BookController extends Controller
{
    public function index(): View
    {
        $books = Book::latest()->paginate(5);
        return view('books.index', compact('books'))
                    ->with('i', (request()->input('page', 1) - 1) * 5);
    }

    public function create(): View
    {
        return view('books.create');
    }

    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'title' => 'required',
            'author' => 'required',
        ]);
        $book = Book::create($request->all());
        return redirect()->route('books.index')->with('success', 'Book created successfully.');
    }
    
    /**
     * Display the specified resource.
     */
    public function show(Book $book): View
    {
        return view('books.show',compact('books'));
    }

    public function edit(Book $book): View
    {
        return view('books.edit', compact('book'));
    }

    public function update(Request $request, Book $book): RedirectResponse
    {
        $request->validate([
            'title' => 'required',
            'author' => 'required',
        ]);
        $book->update($request->all());
        return redirect()->route('books.index')->with('success', 'Book updated successfully.');
    }

    public function destroy(Book $book): RedirectResponse
    {
        $book->delete();
        return redirect()->route('books.index')->with('success', 'Book deleted successfully.');
    }
}
?>
```

### Step 4: Create views

```
php artisan make:view books.index
php artisan make:view books.create
php artisan make:view books.edit
```
These commands will create three view files in the resources/views/books directory: index.blade.php, create.blade.php, and edit.blade.php.
