<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Subject;
use App\Models\Question;
use Redirect;

class QuestionController extends Controller
{
    /**
     * Display az listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
        $questions = Question::all();
        return $questions;
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
        $subjects = Subject::all();
        return view('question.create')->with(['subjects'=>$subjects]);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
      
        $validatedData = $request->validate([
            'question' => ['required','max:100'],
            'option_a' => ['required','max:100'],
            'option_b' => ['required','max:100'],
            'option_c' => ['required','max:100'],
            'option_d' => ['required','max:255'],
            'answer' => ['required','max:255'],
            'subject_id' => ['required'],
        ],
        [
            'question.required' => 'Question is required',
            'question.max' => 'Question should not be greater than 255 characters.',
            'subject_id.required' => 'subject id is required',
            'option_a.required' => 'option a is required',
            'option_b.required' => 'option b is required',
            'option_c.required' => 'option c is required',
            'option_d.required' => 'option d is required',
        ]);
        
        if ($request->answer != $request->option_a && 
            $request->answer != $request->option_b && 
            $request->answer != $request->option_c && 
            $request->answer != $request->option_d) {
               return Redirect::back()->withErrors(['answer' => $request->answer.'-'.$request->option_a.' Answer is not part of the options!']);
        }

        $question = new Question();
        $question->question = $request->question;
        $question->diagram = "";
        $question->option_a = $request->option_a;
        $question->option_b = $request->option_b;
        $question->option_c = $request->option_c;
        $question->option_d = $request->option_d;
        $question->answer = $request->answer;
        $question->subject_id = $request->subject_id;
        $question->save();
        return redirect('questions');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }
    /**
     * Display the specified resource.
     *
     * @param  Request  $request
     * @return \Illuminate\Http\Response
     */
    public function quiz(Request $request)
    {
        //
        $validatedData = $request->validate([
            'subject_id' => ['required'],
        ],
        [
            'subject_id.required' => 'Subject Id is required',
        ]);
        $questionIds = explode(",", $request->previous_questions);
        $questions = Question::where('subject_id',$request->subject_id)->whereNotIn('id', $questionIds)->first();
        return $questions;
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
