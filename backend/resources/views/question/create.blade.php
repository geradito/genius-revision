<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Question</title>
</head>
<body>
    <form action="{{ route('questions.store') }}" method="post" enctype="multipart/form-data">
        @csrf

        @if(session()->has('message'))
            <div class="alert alert-success" style="color:#00ff00">
                {{ session()->get('message') }}
            </div>
        @endif
        <h2>Add new Question</h2>
        
        <div class="form-group">
          <label for="">Question</label><br>
          <textarea name="question" id="question" cols="60" rows="2" class="form-control">{{ old('question') }}</textarea>
            @if($errors->has('question'))
                <div class="error">{{ $errors->first('question') }}</div>
            @endif
        </div><br>
        <div class="form-group">
          <label for="">Image</label>
            <input type="file" class="form-control" name="image" class="form-control" />
            @if($errors->has('image'))
                <div class="error">{{ $errors->first('image') }}</div>
            @endif
        </div><br>
        <div class="form-group">
          <label for="">Option A</label><br>
          <textarea name="option_a" id="option_a" cols="60" rows="2" class="form-control">{{ old('option_a') }}</textarea>
            @if($errors->has('option_a'))
                <div class="error">{{ $errors->first('option_a') }}</div>
            @endif             
        </div><br>
        <div class="form-group">
          <label for="">Option B</label><br>
          <textarea name="option_b" id="option_b" cols="60" rows="2" class="form-control">{{ old('option_b') }}</textarea>
            @if($errors->has('option_b'))
                <div class="error">{{ $errors->first('option_b') }}</div>
            @endif             
        </div><br>
        <div class="form-group">
          <label for="">Option C</label><br>
          <textarea name="option_c" id="option_c" cols="60" rows="2" class="form-control">{{ old('option_c') }}</textarea>
            @if($errors->has('option_c'))
                <div class="error">{{ $errors->first('option_c') }}</div>
            @endif             
        </div><br>
        <div class="form-group">
          <label for="">Option D</label><br>
          <textarea name="option_d" id="option_d" cols="60" rows="2" class="form-control">{{ old('option_d') }}</textarea>
            @if($errors->has('option_d'))
                <div class="error">{{ $errors->first('option_d') }}</div>
            @endif             
        </div><br>
        <div class="form-group">
          <label for="">Answer</label><br>
          <textarea name="answer" id="answer" cols="60" rows="2" class="form-control">{{ old('answer') }}</textarea>
            @if($errors->has('answer'))
                <div class="error">{{ $errors->first('answer') }}</div>
            @endif             
        </div><br>
        <div class="form-group">
          <label for="">Subject</label>
            <select name="subject_id" id="subject_id" required>
                <option value="">--choose option--</option>
                @foreach($subjects as $item)
                    <option value="{{$item->id}}">{{$item->name}}</option>
                @endforeach
            </select> 
        </div><br>
     
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</body>
</html>