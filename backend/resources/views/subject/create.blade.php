<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add subject</title>
</head>
<body>
    <form action="{{ route('subjects.store') }}" method="post">
        @csrf
        <h2>Add new Subject</h2>
        <div class="form-group">
          <label for="">Name</label>
          <input type="text" name="name" id="name" class="form-control" placeholder="Subject name">
            @if($errors->has('name'))
                <div class="error">{{ $errors->first('name') }}</div>
            @endif
        </div>
        <div class="form-group">
          <label for="">Category</label>
            <select name="category_id" id="category_id">
                @foreach($categories as $item)
                    <option value="{{$item->id}}">{{$item->name}}</option>
                @endforeach
            </select> 
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