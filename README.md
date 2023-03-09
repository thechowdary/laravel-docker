# laravel-docker
Use docker for laravel

## Steps to do:

### Step 1: 
- Clone this repo: ```git clone https://github.com/thechowdary/laravel-docker/```
- `git checkout docker_volume`
- You may replace `myproject` word in docker-compose.yml with your project name
- You can change the port number in docker-compose.yml, default set to 8003 in the nginx configuration inside this file.
- Set the database details in the .env file

### Step 2: Files & Database
- Latest laravel files will be pulled from github to ```/var/www/```, Which is the root directory of the project.
- To make changes to project files, please edit using volumes section in visual studio or this location in windows: ```\\wsl$\docker-desktop-data\data\docker\volumes```
- The `.env` file will be copied by default during build process. You may need to set the same `port number` in `.env` file that was set in docker-compose.yml in the first step. 
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
- Make the necessary changes to database environment variables in the `project's .env` file. In my case, `HOST: myproject-db`, Set `Laravel` for Database, username and password.

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
        return view('books.show',compact('book'));
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
These commands will create three view files in the resources/views/books directory: index.blade.php, create.blade.php, and edit.blade.php. If these commands didn't work, then scroll below and make the changes to views directory as mentioned.


===========================

# Alter table columns, if needed. Examples:

- To alter a table, generate schema first, then make changes in the schema, finally migrate it.
- `php artisan make:migration alter_books_table_add_null_to_description`
- Then make the schema like this: 
        ``` 
        Schema::table('books', function (Blueprint $table) {
            $table->string('description')->nullable()->change();
        }); 
        ```
- `php artisan make:migration alter_books_table_add_null_to_price`
- Then make the schema like this: 
        ``` 
        Schema::table('books', function (Blueprint $table) {
            $table->string('price')->nullable()->change();
        }); 
        ```
- `php artisan migrate`


# Other important docker commands

- This will provide all the details including local ip address for db access as a hostname
-  `docker inspect myproject-db`

- To get the newly created controllers, regenerate autoload:
- `docker-compose exec app composer dump-autoload`

- Use namespaces properly in the routes file incase the route didn't work. Don't forget to clear the route cache everytime you update the file. For example: `Route::resource('books', \App\Http\Controllers\BookController::class);`

- To create a new table schema:
- `docker-compose exec app php artisan make:migration create_books_table --create=books`

# Create Views

- Goto `resources/views` and create a folder called `books`(usually table_name)
- Create index.blade.php
```
@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>Books</h1>
                <p>
                    <a href="{{ route('books.create') }}" class="btn btn-primary">Add new book</a>
                </p>
                <table class="table">
                    <thead>
                        <tr>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($books as $book)
                            <tr>
                                <td>{{ $book->title }}</td>
                                <td>{{ $book->author }}</td>
                                <td>
                                    <a href="{{ route('books.show', $book->id) }}" class="btn btn-info">View</a>
                                    <a href="{{ route('books.edit', $book->id) }}" class="btn btn-primary">Edit</a>
                                    <form action="{{ route('books.destroy', $book->id) }}" method="POST" style="display: inline">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this book?')">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
@endsection
```

- Create `create.blade.php` file
```
@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>Add new book</h1>
                <form action="{{ route('books.store') }}" method="POST">
                    @csrf
                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" name="title" id="title" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="author">Author</label>
                        <input type="text" name="author" id="author" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea name="description" id="description" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="price">Price</label>
                        <input type="text" name="price" id="price" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Save</button>
                        <a href="/" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection
```

- Create `edit.blade.php` file
```
@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">{{ __('Edit Book') }}</div>

                    <div class="card-body">
                        <form method="POST" action="{{ route('books.update', $book->id) }}">
                            @csrf
                            @method('PUT')

                            <div class="form-group row">
                                <label for="title" class="col-md-4 col-form-label text-md-right">{{ __('Title') }}</label>

                                <div class="col-md-6">
                                    <input id="title" type="text" class="form-control @error('title') is-invalid @enderror" name="title" value="{{ old('title', $book->title) }}" required autocomplete="title" autofocus>

                                    @error('title')
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $message }}</strong>
                                        </span>
                                    @enderror
                                </div>
                            </div>

                            <div class="form-group row">
                                <label for="author" class="col-md-4 col-form-label text-md-right">{{ __('Author') }}</label>

                                <div class="col-md-6">
                                    <input id="author" type="text" class="form-control @error('author') is-invalid @enderror" name="author" value="{{ old('author', $book->author) }}" required autocomplete="author">

                                    @error('author')
                                        <span class="invalid-feedback" role="alert">
                                            <strong>{{ $message }}</strong>
                                        </span>
                                    @enderror
                                </div>
                            </div>

                            <div class="form-group row mb-0">
                                <div class="col-md-6 offset-md-4">
                                    <button type="submit" class="btn btn-primary">
                                        {{ __('Update Book') }}
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection
```

- Create `show.blade.php` file
```
@extends('layouts.app')

@section('content')
    <div class="row">
        <div class="col-lg-12 margin-tb">
            <div class="pull-left">
                <h2>Show Book</h2>
            </div>
            <div class="pull-right">
                <a class="btn btn-primary" href="{{ route('books.index') }}"> Back</a>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>Title:</strong>
                {{ $book->title }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>Author:</strong>
                {{ $book->author }}
            </div>
        </div>
        <div class="col-xs-12 col-sm-12 col-md-12">
            <div class="form-group">
                <strong>Description:</strong>
                {{ $book->description }}
            </div>
        </div>
    </div>
@endsection
```

- Also, make sure you created a layout file. If not, please create a file called `app.blade.php` file inside `resources/views/layouts` folder.
- The following is a sample bootstrap layout file
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title')</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    @yield('styles')
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="/">My App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('books.index') }}">Books</a>
                </li>
                <!-- Add more menu items here -->
            </ul>
        </div>
    </nav>
    <div class="container mt-4">
        @yield('content')
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper-base.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
    @yield('scripts')
</body>
</html>
```
# Routes Configration
- Add `Route::resource('books', \App\Http\Controllers\BookController::class);` inside the `routes/web.php` file.
