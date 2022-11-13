+*
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Question</title>
</head>
<body>
    <form action="{{ route('questions.update',$question) }}" method="post" enctype="multipart/form-data">
        @csrf
        @method('PUT')
        <h2>Edit Question</h2>
        
        <div class="form-group">
          <label for="">Subject</label>
            <select name="subject_id" id="subject_id">
                @foreach($subjects as $item)
                    <option value="{{$item->id}}" 
                    @if($item->id == $question->subject_id)
                        selected="selected"
                    @endif
                    >{{$item->name}}</option>
                @endforeach
            </select> 
        </div>
        <div class="form-group">
          <label for="">Question</label>
          <input type="text" name="question" id="question" value="{{ $question->question }}" class="form-control" placeholder="Question">
            @if($errors->has('question'))
                <div class="error">{{ $errors->first('question') }}</div>
            @endif
        </div>
        <image src="/public/Image/{{$question->diagram}}" width='100'>
         <div class="form-group">
          <label for="">Image</label>
            <input type="file" class="form-control" name="image" class="form-control" />
            @if($errors->has('image'))
                <div class="error">{{ $errors->first('image') }}</div>
            @endif
        </div>
        <div class="form-group">
          <label for="">Option A</label>
          <input type="text" name="option_a" id="option_a" value="{{ $question->option_a }}" class="form-control" placeholder="Option A">
            @if($errors->has('option_a'))
                <div class="error">{{ $errors->first('option_a') }}</div>
            @endif             
        </div>
        <div class="form-group">
          <label for="">Option B</label>
          <input type="text" name="option_b" id="option_a" value="{{ $question->option_b }}" class="form-control" placeholder="Option B">
            @if($errors->has('option_b'))
                <div class="error">{{ $errors->first('option_b') }}</div>
            @endif             
        </div>
        <div class="form-group">
          <label for="">Option C</label>
          <input type="text" name="option_c" id="option_c" value="{{ $question->option_c }}" class="form-control" placeholder="Option C">
            @if($errors->has('option_c'))
                <div class="error">{{ $errors->first('option_c') }}</div>
            @endif             
        </div>
        <div class="form-group">
          <label for="">Option D</label>
          <input type="text" name="option_d" id="option_d" value="{{ $question->option_d }}" class="form-control" placeholder="Option D">
            @if($errors->has('option_d'))
                <div class="error">{{ $errors->first('option_d') }}</div>
            @endif             
        </div>
        <div class="form-group">
          <label for="">Answer</label>
          <input type="text" name="answer" id="answer" value="{{ $question->answer }}" class="form-control" placeholder="Answer">
            @if($errors->has('answer'))
                <div class="error">{{ $errors->first('answer') }}</div>
            @endif             
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Submit</button>
        </div>
    </form>
</body>
</html>