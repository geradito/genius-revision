<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <title>Genius App|question</title>

        <!-- Fonts -->
        <link href="https://fonts.bunny.net/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
  
        <!-- Styles -->

        <style>
            body {
                font-family: 'Nunito', sans-serif;
            }
        </style>
    </head>
<body>
    <div class="container">
        <div class="row">
            <a href="/">Home</a>
            <div class="col">
                <form action="{{ route('questions.store') }}" method="post" enctype="multipart/form-data">
                    @csrf

                    @if(session()->has('message'))
                        <div class="alert alert-success" style="color:#00ff00">
                            {{ session()->get('message') }}
                        </div>
                    @endif
                    <h2>Add New Question</h2>
                    
                    <div class="form-group">
                    <label for="">Question</label><br>
                    <textarea name="question" id="question" cols="60" rows="1" class="form-control">{{ old('question') }}</textarea>
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
                    <textarea name="option_a" id="option_a" cols="60" rows="1" class="form-control">{{ old('option_a') }}</textarea>
                        @if($errors->has('option_a'))
                            <div class="error">{{ $errors->first('option_a') }}</div>
                        @endif             
                    </div><br>
                    <div class="form-group">
                    <label for="">Option B</label><br>
                    <textarea name="option_b" id="option_b" cols="60" rows="1" class="form-control">{{ old('option_b') }}</textarea>
                        @if($errors->has('option_b'))
                            <div class="error">{{ $errors->first('option_b') }}</div>
                        @endif             
                    </div><br>
                    <div class="form-group">
                    <label for="">Option C</label><br>
                    <textarea name="option_c" id="option_c" cols="60" rows="1" class="form-control">{{ old('option_c') }}</textarea>
                        @if($errors->has('option_c'))
                            <div class="error">{{ $errors->first('option_c') }}</div>
                        @endif             
                    </div><br>
                    <div class="form-group">
                    <label for="">Option D</label><br>
                    <textarea name="option_d" id="option_d" cols="60" rows="1" class="form-control">{{ old('option_d') }}</textarea>
                        @if($errors->has('option_d'))
                            <div class="error">{{ $errors->first('option_d') }}</div>
                        @endif             
                    </div><br>
                    <div class="form-group">
                    <label for="">Answer</label><br>
                    <textarea name="answer" id="answer" cols="60" rows="1" class="form-control">{{ old('answer') }}</textarea>
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
            </div>
            <div class="col">
            <table class="table">
                <thead>
                    <tr>
                    <th scope="col">#</th>
                    <th scope="col">Subject</th>
                    <th scope="col">Grade</th>
                    <th scope="col">Question</th>
                    <th scope="col">Option A</th>
                    <th scope="col">Option B</th>
                    <th scope="col">Option C</th>
                    <th scope="col">Option D</th>
                    <th scope="col">Anwser</th>
                    <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($questions as $item)
                    <tr>
                        <th scope="row">{{$loop->iteration}}</th>
                        <td>{{$item->subject->name}}</td>
                        <td>{{$item->subject->grade->name}}</td>
                        <td>{{$item->question}}</td>
                        <td>{{$item->option_a}}</td>
                        <td>{{$item->option_b}}</td>
                        <td>{{$item->option_c}}</td>
                        <td>{{$item->option_d}}</td>
                        <td>{{$item->answer}}</td>
                        <td><a href="{{$item->id}}/edit">Edit</a></td>
                    </tr>
                    @endforeach
                </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
</body>
</html>
