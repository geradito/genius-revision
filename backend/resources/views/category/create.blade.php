<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Category</title>
</head>
<body>
    <form action="{{ route('categories.store') }}" method="post">
        @csrf
        <h2>Create new Category</h2>
        <div class="form-group">
          <label for="">Name</label>
          <input type="text" name="name" id="name" class="form-control" placeholder="Category name">
            @if($errors->has('name'))
                <div class="error">{{ $errors->first('name') }}</div>
            @endif
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</body>
</html>